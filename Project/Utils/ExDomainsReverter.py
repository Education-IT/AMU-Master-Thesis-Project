import json

with open('data.json', 'r') as file:
    data = json.load(file)

tasks_to_remove = [
    "llmzszl"]

def remove_tasks(data, tasks_to_remove):
    for domain, tasks in data.items():
        for task in tasks_to_remove:
            if task in tasks:
                tasks["count"] -= tasks[task]
                del tasks[task]
    return data

data = remove_tasks(data, tasks_to_remove)

with open('modified_good.json', 'w') as file:
    json.dump(data, file, indent=4)

print("Zadania zostały usunięte i count zaktualizowane.")