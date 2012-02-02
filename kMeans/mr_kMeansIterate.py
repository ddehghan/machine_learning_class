'''
Created on Apr 18, 2011

@author: mike-bowles
'''
from mrjob.job import MRJob

from math import sqrt
from numpy import mat, zeros, shape, random, array, zeros_like
from random import sample
import json

def dist(x,y):
    #euclidean distance between two lists    
    sum = 0.0
    for i in range(len(x)):
        temp = x[i] - y[i]
        sum += temp * temp
    return sqrt(sum)

def plus(x,y):
    #"vector" sum of two lists
    length = len(x)
    sum = [0.0]*length
    for i in range(length):
        sum[i] = x[i] + y[i]
    return sum
        
def divide(x,alpha):
    length = len(x)
    div = [0.0]*length
    for i in range(length):
        div[i] = x[i]/alpha
    return div

class MRkMeansIter(MRJob):
    DEFAULT_PROTOCOL = 'json'
    
    def __init__(self, *args, **kwargs):
        super(MRkMeansIter, self).__init__(*args, **kwargs)
        self.centroids = []                  #current centroid list
        self.new_centroid = []
        fullPath = self.options.pathName + 'intermediateResults.txt'
        fileIn = open(fullPath)
        centroidsJson = fileIn.read()
        fileIn.close()
        self.centroids = json.loads(centroidsJson)
        self.numMappers = 1             #number of mappers
        self.count = 0                  #passes through mapper
        self.count2 = []                #contributors to new_centroid calc in each mapper
                                                 
    def configure_options(self):
        super(MRkMeansIter, self).configure_options()

        self.add_passthrough_option(
            '--k', dest='kMeans', default=2, type='int',
            help='k: number of means (cluster centroids)')
        self.add_passthrough_option(
            '--pathName', dest='pathName', default="//home//mike-bowles//pyWorkspace//mapReducers//src//kMeans3//", type='str',
            help='pathName: pathname where intermediateResults.txt is stored')
        
    def mapper(self, key, val):
        #determine closest centroid for each val in input
        #map each val onto closest centroid 
        x = json.loads(val)
        
        if self.count == 0:
            #initialize this mapper's copy of self.new_centroid to zero
            #initialize this mapper's copy of self.count2 to all zeros
            self.count = 1
            self.new_centroid = []
            self.count2 = [0.0]*self.options.kMeans
            for i in range(self.options.kMeans):
                temp = [0.0]*len(x)
                self.new_centroid.append(temp)
                        
        
        dist1 = dist(x,self.centroids[0])
        index = 0
        for i in range(1,self.options.kMeans):
            dist2 = dist(array(x),array(self.centroids[i]))
            if(dist2 < dist1):
                index = i
                dist1 = dist2
        self.count2[index] += 1
        temp = self.new_centroid[index]
        self.new_centroid[index] = plus(temp,x)
        if False: yield 1,2
        
    def mapper_final(self):
        out = [self.new_centroid,self.count2]
        jOut = json.dumps(out)
        yield 1,jOut
    
    
    def reducer(self, key, xs):
        #add up the centroid sums from all the mappers
        #add up the number of points in each centroid calc from each mapper
        counts = [0.0]*self.options.kMeans
        centroid_sum = []
        first = True
        #accumulate partial sums
        for val in xs:
            if first:
                temp = json.loads(val)
                cent = temp[0]
                cnt = temp[1]
                centroid_sum = cent
                counts = cnt
                first = False
            else:
                temp = json.loads(val)
                cent = temp[0]
                cnt = temp[1]
                for k in range(self.options.kMeans):
                    temp = centroid_sum[k]
                    centroid_sum[k] = plus(temp,cent[k])
                    counts[k] = counts[k] + cnt[k]
        #divide grand sum by number of points
        newCentroid = []
        for k in range(self.options.kMeans):
            newCentroid.append(divide(centroid_sum[k],counts[k]))
            
        #write new centroids to file
        centOut = json.dumps(newCentroid)
        fullPath = self.options.pathName + 'intermediateResults.txt'
        fileOut = open(fullPath,'w')
        fileOut.write(centOut)
        fileOut.close()
        if False: yield 1,2
        
    #def steps(self):
        #return ([self.mr(mapper=self.mapper,reducer=None,mapper_final=None)])
            

if __name__ == '__main__':
    MRkMeansIter.run()