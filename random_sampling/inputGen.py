'''
Created on Feb 21, 2011

@author: mike-bowles
'''
import os
from numpy import random
import json


PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))

fileOut=open(os.path.join(PROJECT_ROOT , 'input.txt'),"w")


for i in range(100):
    num = i #random.rand()
    fileOut.write(str([num]) + '\n')

fileOut.close()
    