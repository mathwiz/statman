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
    data['PaTDPG'] = round(data['PaTD'] / data['G'], 2)
    data['RuTDPG'] = round(data['RuTD'] / data['G'], 2)
    data['ReTDPG'] = round(data['ReTD'] / data['G'], 2)
    data['PaYPG'] = round(data['PaYds'] / data['G'], 2)
    data['RuYPG'] = round(data['RuYds'] / data['G'], 2)
    data['ReYPG'] = round(data['ReYds'] / data['G'], 2)
    data['PaAPG'] = round(data['PaAtt'] / data['G'], 2)
    data['RuAPG'] = round(data['RuAtt'] / data['G'], 2)
    data['ReRPG'] = round(data['ReRec'] / data['G'], 2)
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


def get_key(row):
    return row['Key']


def get_season(row):
    return row['Season']


def get_ppg(row, stat):
    games = row['G']
    return ppg(row[stat], games)


def ppg(val, games):
    return 0.0 if games == 0 else round(val / games, 2)


def next_year_dkg(row):
    dkg = draftKings[get_key(row)].get(get_season(row) + 1)
    return dkg if dkg else np.NaN



# do transforms
new_vars(all)
build_map(all)
actual_fantasy(all)

# output


# testing
# print(all.mean(axis=0)['Age'])
# print(draftKings['JohnDa08'])
# print(draftKings['ElliEz00'])
# print(draftKings['McCoLe01'])
# print(draftKings['RodgAa00'])
print(all.loc[all['FantPos'] == 'QB'].head())
print(all.loc[all['FantPos'] == 'RB'].head())
print(all.loc[all['FantPos'] == 'WR'].head())
print(all[570:580])
