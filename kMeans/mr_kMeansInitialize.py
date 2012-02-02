'''
Created on Apr 18, 2011

@author: mike-bowles
'''
import os
from mrjob.job import MRJob

from numpy import mat, zeros, shape, random, array, zeros_like
from random import sample
import json


PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))

class MRkMeansInit(MRJob):
    DEFAULT_PROTOCOL = 'json'
    
    def __init__(self, *args, **kwargs):
        super(MRkMeansInit, self).__init__(*args, **kwargs)
        self.centroids = []                  #current centroid list
        self.numMappers = 1             #number of mappers
        self.count = 0
                                                 
    def configure_options(self):
        super(MRkMeansInit, self).configure_options()
        self.add_passthrough_option(
            '--k', dest='kMeans', default=2, type='int',
            help='k: number of means (cluster centroids)')
        self.add_passthrough_option(
            '--pathName', dest='pathName', default=PROJECT_ROOT, type='str',
            help='pathName: pathname where intermediateResults.txt is stored')
        
    def mapper(self, key, xjIn):
        #something simple to grab random starting point
        #collect the first 2k
        if self.count <= 2*self.options.kMeans:
            self.count += 1
            yield (1,xjIn)        
        
    def reducer(self, key, xjIn):        
        #accumulate data points mapped to 0 from 1st mapper and pull out k of them as starting point
        cent = []
        for xj in xjIn:
            x = json.loads(xj)
            cent.append(x)
            yield 1, xj
        index = sample(range(len(cent)), self.options.kMeans)
        cent2 = []
        for i in index:
            cent2.append(cent[i])
               
        centOut = json.dumps(cent2)
        #put centroids onto file to load in at next instantiation of "self"
        fullPath = os.path.join(self.options.pathName , 'intermediateResults.txt')
        fileOut = open(fullPath,'w')
        fileOut.write(centOut)
        fileOut.close()

if __name__ == '__main__':
    MRkMeansInit.run()