'''
Created on Mar 18, 2011

@author: mike-bowles
'''
import os
from numpy import random
import json

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))


fileOut=open(os.path.join(PROJECT_ROOT , 'input.txt'),"w")
fileOut2=open(os.path.join(PROJECT_ROOT , 'input.csv'),"w")
#generate a 2-dim example.  5 centers picked randomly in (0,10) each with
#100 samples of gaussian unit variance samples


# example of 5 centers:
#centers = []
#ncenters = 5
#for i in range(ncenters):
#    x = 10*random.uniform()
#    y = 10*random.uniform()
#    centers.append([x,y])

# 2 centers example:
centers = []
ncenters = 2
centers.append([0.0,0.0])
centers.append([2.0,2.0])

for i in range(1000):
    for j in range(ncenters):
        xm = centers[j][0]
        ym = centers[j][1]
        x = random.normal(xm,1.0,1)[0]
        y = random.normal(ym,1.0,1)[0]
        outString = json.dumps([x,y]) + "\n"

        fileOut.write(outString)
        fileOut2.write(str(x) +  "," + str(y) + "\n")

fileOut.close()

