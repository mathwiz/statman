import numpy as np
import pandas as pd
import fantasymunger as fm

all = pd.read_csv("/Users/yohanlee/Cloud/Data/Nfl/fantasy/augmented/fantasy_all.csv")

print(all.head())
print(all.tail())

print(all.loc[all['Key'] == 'JohnDa08'])
