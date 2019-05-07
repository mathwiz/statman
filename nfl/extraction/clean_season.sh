#!/bin/bash

SRC_DIR=/Users/yohanlee/Cloud/Data/Nfl/teams/raw
DEST_DIR=/Users/yohanlee/Cloud/Data/Nfl/teams/cleaned
YEAR=$1

cat $SRC_DIR/$YEAR.html \
| perl tables_raw.pl \
| perl tables_w_key.pl \
> $DEST_DIR/$YEAR.csv
