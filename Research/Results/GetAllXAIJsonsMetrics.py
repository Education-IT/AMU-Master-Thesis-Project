import os
import json
import pandas as pd

def extract_data_from_json(json_path):
    try:
        with open(json_path, "r", encoding="utf-8") as file:
            data = json.load(file)
        
        return {
            "task": data.get("task", "N/A"),
            "questions": data.get("questions", -1),
            "noWebContextCount": data.get("noWebContextCount", -1),
            "contaminated_queries": data.get("contaminated_queries", -1),
            "contaminated_urls": data.get("contaminated_urls", -1),
            "valid_urls": data.get("valid_urls", -1),
            "avg_contaminated_before_valid": data.get("avg_contaminated_before_valid", -1.0),
            "contaminated_data_ratio": data.get("contaminated_data_ratio", -1.0)
        }
    except (json.JSONDecodeError, FileNotFoundError) as e:
        print(f"Error: {json_path}: {e}")
        return None

def scan_dic(base_folder):
    results = []
    
    for root, _, files in os.walk(base_folder):
        for file in files:
            if file.endswith(".json"):
                json_path = os.path.join(root, file)
                data = extract_data_from_json(json_path)
                if data:
                    results.append(data)
    
    return results

def main():
    base_folder = "./"
    extracted_data = scan_dic(base_folder)
    
    df = pd.DataFrame(extracted_data)
    print(df.head())
    
    df.to_csv("xaiko.csv", index=False,sep=";")
    print("DONE")

if __name__ == "__main__":
    main()
