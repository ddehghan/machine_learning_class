'''
Created on Apr 18, 2011

@author: mike-bowles
'''
from mrSample import mrSample
import json
from math import sqrt
import os


PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))



def main():
    #first run the initializer to get starting centroids
    filePath =  os.path.join(PROJECT_ROOT, 'input.txt')
    mrJob = mrSample(args=[filePath])
    with mrJob.make_runner() as runner:
        runner.run()

    #pull out the centroid values to compare with values after one iteration
#    centPath = os.path.join(PROJECT_ROOT, 'intermediateResults.txt')
#    fileIn = open(centPath)
#    centroidsJson = fileIn.read()
#    fileIn.close()

#    delta = 10
#    #Begin iteration on change in centroids
#    while delta > 0.001:
#        #parse old centroid values
#        oldCentroids = json.loads(centroidsJson)
#        #run one iteration
#        mrJob2 = MRkMeansIter(args=[filePath])
#        with mrJob2.make_runner() as runner:
#            runner.run()
#
#        #compare new centroids to old ones
#        fileIn = open(centPath)
#        centroidsJson = fileIn.read()
#        fileIn.close()
#        newCentroids = json.loads(centroidsJson)
#
#        kMeans = len(newCentroids)
#
#        delta = 0.0
#        for i in range(kMeans):
#            delta += dist(newCentroids[i],oldCentroids[i])
#
#        print "delta={0},  centers={1}" .format(delta, str(newCentroids))

if __name__ == '__main__':
    main()