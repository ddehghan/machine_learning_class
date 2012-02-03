'''
Created on Feb 1, 2012

@author:
'''
import os
import random
from mrjob.job import MRJob
from math import sqrt
import json

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))


class mrSample(MRJob):
    #DEFAULT_PROTOCOL = 'raw_value'
    #DEFAULT_PROTOCOL = 'json_value'
    DEFAULT_PROTOCOL = 'json'

    def __init__(self, *args, **kwargs):
        super(mrSample, self).__init__(*args, **kwargs)
        self.samples = []                  #current centroid list
        self.count = 0

    def configure_options(self):
        super(mrSample, self).configure_options()
        self.add_passthrough_option(
            '--k', dest='sample_size', default=10, type='int',
            help='k: number of samples')

    def mapper(self, key, line):
        
        num = json.loads(line)

        self.count += 1
        if len(self.samples) <= self.options.sample_size:
            self.samples.append(num)
        else:
            expected_prob = (self.options.sample_size*1.0) / self.count
            actual_prob = random.random()
            if actual_prob <= expected_prob:
                index = random.randint(0,self.options.sample_size)
                self.samples[index] = num

    def mapper_final(self):
        out = [self.count, self.samples]
        jOut = json.dumps(out)
        yield 1,jOut

  
    def reducer(self, n, vars):

        samples = []
        for x in vars:
            input = json.loads(x)
            count=input[0]
            sub_samples=input[1]

            samples.append(sub_samples)

        yield 1, samples

if __name__ == '__main__':
    mrSample.run()
