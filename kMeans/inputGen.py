'''
Created on Mar 18, 2011

@author: mike-bowles
'''
import os

from numpy import random
import json

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))


filename=os.path.join(PROJECT_ROOT , 'input.txt')
fileOut=open(filename,"w")
#generate a 2-dim example.  5 centers picked randomly in (0,10) each with 
#100 samples of gaussian unit variance samples


centers = []
ncenters = 5
for i in range(ncenters):
    x = 10*random.uniform()
    y = 10*random.uniform()
    centers.append([x,y])
    
centers = []
ncenters = 2
centers.append([0.0,0.0])
centers.append([2.0,2.0])

for i in range(100):
    for j in range(ncenters):
        xm = centers[j][0]
        ym = centers[j][1]
        x = random.normal(xm,1.0,1)[0]
        y = random.normal(ym,1.0,1)[0]
        outString = json.dumps([x,y]) + "\n"
        fileOut.write(outString)
        
fileOut.close()

