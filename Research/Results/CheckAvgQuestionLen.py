import os
import json
import pprint
from collections import OrderedDict
xlist = {
    
}

for filename in os.listdir("."):
    if filename.endswith(".json"):
        
        with open(filename,"r",encoding="UTF-8") as f:
            data = json.load(f)
            suma = 0
            if "most_contaminated_domains" in data: 
                length = data["valid_urls_count"]
                dic = data["valid_urls"]
                for x in dic:
                    suma += len(x["query"])
                
                Result = suma//length
                xlist[filename] = Result
       
xlist = OrderedDict(sorted(xlist.items(),key=lambda item: item[1],reverse=True))
with open("analizer-question.json","w",encoding="UTF-8") as f2:
    json.dump(xlist,f2,indent=4)

pprint.pprint(xlist)