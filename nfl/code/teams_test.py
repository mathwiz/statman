import sys
import re
import sys
import csv
import datetime
import teams as t


file = sys.argv[1]
line_num = 0

with open(file) as f:
    for line in f:
        line_num += 1
        if line_num == 1 or re.search(r'"END GAME"',line):
            print(line.rstrip())

