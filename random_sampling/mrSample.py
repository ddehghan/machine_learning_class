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
        self.samples = []
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
            expected_prob = (self.options.sample_size * 1.0) / self.count
            actual_prob = random.random()
            if actual_prob <= expected_prob:
                index = random.randint(0, self.options.sample_size)
                self.samples[index] = num

    def mapper_final(self):
        out = [self.count, self.samples]
        jOut = json.dumps(out)
        yield 1, jOut


    def reducer(self, n, vars):
        samples_from_mappers = []
        counts_from_mappers = []

        total_counts_from_mappers = 0
        final_samples = []
        for x in vars:
            input = json.loads(x)
            total_counts_from_mappers += input[0]

            counts_from_mappers.append(input[0])
            samples_from_mappers.append(input[1])

        i = 0
        for mapper in samples_from_mappers:
            weight = counts_from_mappers[i] * 1.0 / total_counts_from_mappers
            number_of_needed_samples = int(weight * self.options.sample_size)
            for j in range(number_of_needed_samples):
                final_samples.append(mapper.pop())
            i += 1


        yield 1, final_samples

if __name__ == '__main__':
    mrSample.run()
