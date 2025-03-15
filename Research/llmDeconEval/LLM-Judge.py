import json
from openai import OpenAI
from dotenv import load_dotenv
import os


load_dotenv()
api_key = os.getenv("API_KEY")
client = OpenAI(api_key=api_key)

def openAIQ(question,answer):
    completion = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": """
You are a tool that verifies the performance of the contaminated content detector. Your task is to write GOOD/BAD depending on whether the fragment sent is contaminated and whether it resembles the question asked. I.e. When You can see that the answer to the question asked, contains the same question or sounds identical (synonyms used). It may also resemble the test (abcd). If you are not sure, write HUMAN_CHECK. 
Examples
If in doubt: write "HUMAN_CHECK"
#ex1 User: Question: "which part of a plant takes in water and nutrients from the soil" Answer: "the essential part of a plant that fulfills the crucial roles of anchoring it in the soil and absorbing water and nutrients is the root" AI: GOOD
#ex2 User: Question: "students are investigating the physical properties of three solid mixtures by placing each solid mixture in liquid water what physical property are the students testing" Answer "physical properties of three solid mixtures by placing each solid mixture in liquid water what physical property are the students testing 2 solubility"  AI: BAD
#ex3 User: Question: "which is a statement of fact" Answer: "during the decision preparation process your case manager might create a statement of facts this is a list of facts about the claim" AI: GOOD
#ex4 User: Question: "what keeps the planets in orbit around the sun" Answer: "the gravity of the sun keeps the planets in their orbits they stay in their orbits because there is no other force in the solar system which can stop them" AI: GOOD
#ex5 User: Question: "the phases of the moon are caused by the" Answer: "this effect is caused by the suns light reflecting off earths surface onto the face of the moon" AI: GOOD
#ex6 User: Question: "people often wear sunglasses in polar regions because most of the sunlight that strikes a snowcovered surface is" Answer: "people often wear sunglasses in polar regions because most of the sunlight that strikes a snow covered surface is answers answer 1 reflected" AI: BAD
#ex7 User: Question: "a student sees many plants around a pond the student can determine which plants are nonvascular by" Answer: nonvascular 10 a student sees many plants around a pond the student can determine which plants are nonvascular by — 2007 test question 38 a observing 3 pages" AI: BAD
#ex8 User: Question: "compared to the particles in a hardened lava sample the particles in a liquid lava sample" Answer: "39 compared to the particles in a hardened lava sample the particles in a liquid lava sample 1 have a lower temperature 2 have less kinetic energy 3" AI: BAD
#ex9 User: Question: "as stream velocity decreases which factor will likely increase" Answer: "stream discharge rates can also increase dramatically as a result of the as the velocity decreases some of the suspended sediments will be deposited" AI: GOOD
#ex10 User: Question: "all organisms process nutrients which sentence best describes how plants and animals process nutrients similarly" Answer: "plants are producers they take energy from the sun nutrients from the ground and water to grow and produce their flowers seeds and berries they also 21 pages" AI: GOOD"""},
            {
                "role": "user",
                "content": f"User: Question: \"{question}\" Answer: \"{answer}\" AI: "
            }
        ]
    )
    return completion.choices[0].message.content


OK = 0
NOK = 0
i = 0
result = {"data": [], "result": {"GOOD": 0, "BAD": 0}}

with open('XAI_WEB_ARC-Easy_final.json', 'r', encoding='utf-8') as file:
    data = json.load(file)
    data = data["contaminated_WebContext"]

for obj in data:
    i += 1
    response = openAIQ(obj["query"], obj["content"])
    if response == "GOOD":
        OK += 1
        result["result"]["GOOD"] += 1
        obj["result"] = "GOOD"
        result["data"].append(obj)
        print(f"{i}) --> OK")
    elif response == "BAD":
        NOK += 1
        result["result"]["BAD"] += 1
        obj["result"] = "BAD"
        result["data"].append(obj)
        print(f"{i}) --> NOK")
    else:
        print(response)
        print(obj["query"])
        print(obj["content"])
        x = input(f"{i}) --> OK/NOK?  ")
        if x == "GOOD":
            OK += 1
            result["result"]["GOOD"] += 1
            obj["result"] = "GOOD"
            result["data"].append(obj)
        elif x == "BAD":
            NOK += 1
            result["result"]["BAD"] += 1
            obj["result"] = "BAD"
            result["data"].append(obj)
        else:
            obj["result"] = "ERROR"
            print("Error")

with open('XAI_WEB_ARC-Easy_final_NOK_BAD.json', 'w', encoding='utf-8') as result_file:
    json.dump(result, result_file, ensure_ascii=False, indent=4)

print(f"Question: {len(data)} || OK: {OK} NOK: {NOK}")