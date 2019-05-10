import sys
import numpy as np
import pandas as pd
import fantasymunger as fm

file = sys.argv[1]
print("Processing", file)
all = pd.read_csv(file)

print(all.head())
print(all.tail())

print(all.loc[all['Key'] == 'JohnDa08'])
