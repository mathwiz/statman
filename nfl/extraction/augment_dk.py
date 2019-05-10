import sys
import numpy as np
import pandas as pd
import fantasymunger as fm

file = sys.argv[1]
print("Processing", file, "\n")
all = pd.read_csv(file)

print(all.head())
print(all.tail())

draftKings = {}

def actual_fantasy(data):
    for x in data.iterrows():
        row = x[1]
        key = get_key(row)
        season = get_season(row)
        if not draftKings.get(key):
            draftKings[key] = {}
        draftKings[key][season] = get_points(row)


def get_key(row):
    return row['Key']


def get_season(row):
    return row['Season']


def get_points(row):
    games = row['G']
    return 0.0 if games == 0 else row['DKPt'] / games


actual_fantasy(all)
print(draftKings['RodgAa00'])
print(draftKings['JohnDa08'])
print(draftKings['ElliEz00'])
print(draftKings['GurlTo01'])
