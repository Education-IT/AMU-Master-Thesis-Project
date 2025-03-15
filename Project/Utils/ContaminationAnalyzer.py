import os
import json
import pprint
from collections import OrderedDict
xlist = {
    
}

for filename in os.listdir("."):
    if filename.endswith(".json"):
        try:
            with open(filename,"r",encoding="UTF-8") as f:
                data = json.load(f)
                if "most_contaminated_domains" in data:
                    dic = data["most_contaminated_domains"]
                    for x in dic.items():
                        if x[0] in xlist:
                            xlist[x[0]] = xlist[x[0]] + x[1]
                        else:
                            xlist[x[0]] = x[1]
        except:
            print("ERROR")
xlist = OrderedDict(sorted(xlist.items(),key=lambda item: item[1],reverse=True))
with open("analizer.json","w",encoding="UTF-8") as f2:
    json.dump(xlist,f2,indent=4)

pprint.pprint(xlist)