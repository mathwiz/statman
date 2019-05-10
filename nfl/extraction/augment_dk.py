import sys
import numpy as np
import pandas as pd
import fantasymunger as fm

file = sys.argv[1]
outfile = sys.argv[2]
print("Processing", file, "\n")
all = pd.read_csv(file)

draftKings = {}

def new_vars(data):
    data['PaYPG'] = np.NaN
    data['RuYPG'] = np.NaN
    data['ReYPG'] = np.NaN
    data['NextDKG'] = np.NaN


def build_map(data):
    for x in data.iterrows():
        row = x[1]
        key = get_key(row)
        season = get_season(row)
        if not draftKings.get(key):
            draftKings[key] = {}
        draftKings[key][season] = get_ppg(row, 'DKPt')


def actual_fantasy(data):
    for index, row in data.iterrows():
        data.loc[index, 'NextDKG'] = next_year_dkg(row)
        data.loc[index, 'PaYPG'] = get_ppg(row, 'PaYds')
        data.loc[index, 'RuYPG'] = get_ppg(row, 'RuYds')
        data.loc[index, 'ReYPG'] = get_ppg(row, 'ReYds')


def get_key(row):
    return row['Key']


def get_season(row):
    return row['Season']


def get_ppg(row, stat):
    games = row['G']
    return 0.0 if games == 0 else round(row[stat] / games, 2)


def next_year_dkg(row):
    dkg = draftKings[get_key(row)].get(get_season(row) + 1)
    return dkg if dkg else np.NaN



# do transforms
new_vars(all)
build_map(all)
actual_fantasy(all)

# output


# testing
print(draftKings['JohnDa08'])
print(draftKings['ElliEz00'])
print(draftKings['McCoLe01'])
print(draftKings['RodgAa00'])
print(all.head(10))
print(all.tail(10))
