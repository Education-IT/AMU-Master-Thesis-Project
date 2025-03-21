import json

with open('RawExDomains.json', 'r') as file:
    data = json.load(file)

tasks_to_remove = ["bbh_zeroshot_formal_fallacies","bbh_zeroshot_penguins_in_a_table","bbh_zeroshot_tracking_shuffled_objects_three_objects","polemo2_in","polemo2_out"]

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