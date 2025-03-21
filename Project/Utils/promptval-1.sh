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
        "openai-community/openai-gpt"
        #"openai-community/gpt2"
        "openai-community/gpt2-xl"
        #"meta-llama/Llama-3.2-1B-Instruct" 
        #"meta-llama/Llama-3.2-1B" 
        #"TinyLlama/TinyLlama_v1.1"
        #"HuggingFaceTB/SmolLM2-1.7B-Instruct"
        #"HuggingFaceTB/SmolLM2-1.7B"
        #"Qwen/Qwen2.5-1.5B-Instruct"
        #"Qwen/Qwen2.5-1.5B" 
        #"google/gemma-2-2b"
        #"google/gemma-2-2b-it"
        #"meta-llama/Llama-3.2-3B"
        #"meta-llama/Llama-3.2-3B-Instruct"
        #"Qwen/Qwen2.5-3B"
        #"Qwen/Qwen2.5-3B-Instruct"
        #"deepseek-ai/deepseek-llm-7b-base"
        #"microsoft/Phi-3.5-mini-instruct"
        #"allenai/OLMo-2-1124-7B-Instruct"
        # "mistralai/Mistral-7B-v0.3"
        # "mistralai/Mistral-7B-Instruct-v0.3"
        # "microsoft/Phi-3.5-mini-instruct"
        #"Qwen/Qwen2.5-7B-Instruct"
        "Qwen/Qwen2.5-7B"
        "meta-llama/Meta-Llama-3-8B"
        "meta-llama/Meta-Llama-3-8B-Instruct"
        )


BENCHMARKS=("ai2_arc,mmlu")
WEB_PROMPTS=(
    # ""
    # "Info:"
    # "Data:"
    # "Context:"
    # "WebContext:"
    # "Information:"
    # "Concept:" 
    # "Reference:"
    "This is a snippet from the internet, retrieved from a trusted source. It contains useful information that may help in solving the task:"
    "Context retrieved from the internet for reference:"
    "Use this internet-sourced context to answer the question:"
    # "This is a snippet from the internet that may help with the task:"
    # "Helpful information from the internet for solving the task:"
    #"Data from the Internet useful for solving the task:"
)   

LOGS_DIR="$HOME/logs_1903"
huggingface-cli login --token ...
mkdir -p "$LOGS_DIR"
cd lm-evaluation-harness

for MODEL in "${MODELS[@]}"; do
    safe_model_name="${MODEL//\//--}"
    model_cache_path="$HOME/.cache/huggingface/hub/models--${safe_model_name}"

    model_log_file="$LOGS_DIR/${safe_model_name}.out"
    touch "$model_log_file"

    for BENCHMARK in "${BENCHMARKS[@]}"; do
        echo "\n### Benchmark: $BENCHMARK ###" >> "$model_log_file"
        
        for WEB_PROMPT in "${WEB_PROMPTS[@]}"; do
            echo "\n### Web Prompt: '$WEB_PROMPT' ###" >> "$model_log_file"

            lm_eval --model hf --model_args pretrained=$MODEL --tasks $BENCHMARK --device cuda:0 \
                    --web_access --web_data_action load --file_sufix final --web_prompt "$WEB_PROMPT" --web_ \
                    --batch_size auto >> "$model_log_file"

            echo -e "### End of Web Prompt: '$WEB_PROMPT' ###\n" >> "$model_log_file"
        done
        echo -e "### End of $BENCHMARK ###\n" >> "$model_log_file"
    done
    rm -rf "$model_cache_path"
done