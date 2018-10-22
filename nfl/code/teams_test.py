import sys
import csv
import teams as t


file = sys.argv[1]
line_num = 0

teams = {}

with open(file) as f:
    reader = csv.DictReader(f)
    teams = t.load_from_reader(reader)

print(teams)            