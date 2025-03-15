# Documentation:

### 1. First, start the SearXNG search engine and connect your API key to the Brave search engine

### 2. Next, run lm_evaluation_harness with the available flags:

``` powershell
# Adds a snippet to each question from the test corpus  
--web_access (-web)  
```

``` powershell
# Creates a new corpus with the specified name. Defaults to "eval."  
--web_data_action (-wda) <load/save>  
```

``` powershell
# Loads or saves a corpus with the name specified by the user  
--file_suffix (-fs) <string>  
```

``` powershell
# Example program execution  
lm_eval --model hf --model_args pretrained=openai-community/openai-gpt --tasks arc_easy --device cuda:0 --batch_size auto --web_access --web_data_action save --file_suffix final  
```
### Additional Information:
- Data is stored in: ./cache/huggingface/datasets/<dataset_name>/web_access_<corpus_name><task_name><suffix>
- After each retrieval of a dataset enriched with snippets, an additional file is created containing useful information:

``` C#
 metrics = {
            "task": string,
            "dataset": string,
            "questions": int,
            "noWebContextCount": int,
            "contaminated_queries": int,
            "contaminated_urls": int,
            "valid_urls": int,
            "avg_contaminated_before_valid": float,
            "contaminated_data_ratio": float,
            "most_contaminated_urls": list,
            "noWebContext": list,
            "contaminated_WebContext": list,
            "valid_WebContext": list 
        }
```

<hr>

### Adding logs:
``` python
eval_logger.info(f"")
```
