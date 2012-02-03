# Copyright 2009-2010 Yelp
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""The classic MapReduce job: count the frequency of words.
"""
from string import lower
from mrjob.job import MRJob

def is_common(word):
    if word in ["or","and", "is", "have", "has", "in", "on", "*", "#"]:
        return True
    return False


class MRWordFreqCount(MRJob):
    def mapper(self, _, line):
    #        import pdb; pdb.set_trace()

#        for word in line.split():
#            if not is_common(word):
#                continue
#
#            yield word, 1
        for c in line:
            yield lower(c), 1

    def combiner(self, word, counts):
        yield (word, sum(counts))

    def reducer(self, word, counts):
        yield (word, sum(counts))


if __name__ == '__main__':
    MRWordFreqCount.run()
