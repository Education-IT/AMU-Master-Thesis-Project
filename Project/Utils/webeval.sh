#!/usr/bin/env bash
#SBATCH --job-name=kord
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=20G
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=osinski.krystian.1999@gmail.com

eval "$(conda shell.bash hook)"
conda activate llm-conda

MODELS=(
    #"openai-community/openai-gpt"
    #"openai-community/gpt2"
    #"openai-community/gpt2-medium"
    "openai-community/gpt2-large"
    "openai-community/gpt2-xl"
    
    "microsoft/Phi-3.5-mini-instruct"

    "google/gemma-2-2b"
    "google/gemma-2-2b-it"

    "mistralai/Mistral-7B-v0.3"
    "mistralai/Mistral-7B-Instruct-v0.3"

    "HuggingFaceTB/SmolLM2-135M"
    "HuggingFaceTB/SmolLM2-135M-Instruct"
    "HuggingFaceTB/SmolLM2-360M"
    "HuggingFaceTB/SmolLM2-360M-Instruct"
    "HuggingFaceTB/SmolLM2-1.7B"
    "HuggingFaceTB/SmolLM2-1.7B-Instruct"

    "allenai/OLMo-2-1124-7B"
    "allenai/OLMo-2-1124-7B-Instruct"

    "deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B"
    "deepseek-ai/DeepSeek-R1-Distill-Qwen-7B"
    "deepseek-ai/DeepSeek-R1-Distill-Llama-8B"

    "Qwen/Qwen2.5-0.5B"
    "Qwen/Qwen2.5-0.5B-Instruct"
    "Qwen/Qwen2.5-1.5B"
    "Qwen/Qwen2.5-1.5B-Instruct"
    "Qwen/Qwen2.5-3B"
    "Qwen/Qwen2.5-3B-Instruct"
    "Qwen/Qwen2.5-7B"
    "Qwen/Qwen2.5-7B-Instruct"

    "TinyLlama/TinyLlama_v1.1"

    "meta-llama/Llama-3.2-1B"
    "meta-llama/Llama-3.2-1B-Instruct"
    "meta-llama/Llama-3.2-3B"
    "meta-llama/Llama-3.2-3B-Instruct"
    "meta-llama/Llama-3.1-8B"
    "meta-llama/Llama-3.1-8B-Instruct"
    
    "CYFRAGOVPL/Llama-PLLuM-8B-instruct"
    "OPI-PG/Qra-1b"
    "OPI-PG/Qra-7b"
    "speakleash/Bielik-7B-Instruct-v0.1"
    "speakleash/Bielik-7B-v0.1"
)

BENCHMARKS=(
    #"webqs"
    #"ai2_arc"
    #"headqa_en"
    #"plmoab"
    #"arc_challenge_mt_pl"
    #"mmlu"
    #"openbookqa"
    #"sciq"
    #"llmzszl"
    #"agieval_en"  -- !--PROBLEM--!
    #"qasper_bool" -- !--PROBLEM--!
    #"gpqa_main_zeroshot"
    #"groundcocoa"
    #"polish_dyk_multiple_choice"
    #"commonsense_qa"
    #"toxigen"
    #"glue"         -- !Długo się robi, mało wnosi!
    #"arithmetic" "  -- !Długo się robi, mało wnosi!
    #"gsm8k" #1.32k rows
    #"polemo2" #1k
    "polish_polqa_closed_book"
    "nq_open" # 3.5k rows
    "triviaqa" #17.6k rows
    "glue"         #-- !Długo się robi, mało wnosi!
    "arithmetic"   #-- !Długo się robi, mało wnosi!
    #"bbh_zero_shot"
)
PROMPT="Useful concept:"
LOGS_DIR="$HOME/logs_webeval_gu2"

huggingface-cli login --token ...
mkdir -p "$LOGS_DIR"
cd lm-evaluation-harness

for MODEL in "${MODELS[@]}"; do
    safe_model_name="${MODEL//\//--}"
    model_cache_path="$HOME/.cache/huggingface/hub/models--${safe_model_name}"
    model_log_file="$LOGS_DIR/${safe_model_name}.out"
    touch "$model_log_file"

    for BENCHMARK in "${BENCHMARKS[@]}"; do
        echo -e "\n### Benchmark: $BENCHMARK ###" >> "$model_log_file"

        # Klasyczna ewaluacja
        echo -e "\n### Classic Evaluation ###" >> "$model_log_file"
        lm_eval --model hf --model_args pretrained=$MODEL --tasks $BENCHMARK --device cuda:0 \
                --batch_size auto --trust_remote_code --confirm_run_unsafe_code >> "$model_log_file"

        # Ewaluacja z kontekstem z internetu
        echo -e "\n### Web Context Evaluation ###" >> "$model_log_file"
        lm_eval --model hf --model_args pretrained=$MODEL --tasks $BENCHMARK --device cuda:0 \
                --web_access --web_data_action load --file_sufix final --web_prompt "$PROMPT" \
                --batch_size auto  --trust_remote_code --confirm_run_unsafe_code >> "$model_log_file"

        echo -e "------------------------------------------------------------------" >> "$model_log_file"
        echo -e "------------------------------------------------------------------" >> "$model_log_file"
        echo -e "------------------------------------------------------------------" >> "$model_log_file"

    done
    rm -rf "$model_cache_path"
done
