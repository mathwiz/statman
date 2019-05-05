#!/bin/bash

SRC_DIR=/Users/yohanlee/Cloud/Data/Nfl/fantasy/raw
DEST_DIR=/Users/yohanlee/Cloud/Data/Nfl/fantasy/cleaned
YEAR=$1

cat $SRC_DIR/$YEAR.html \
| perl tables_raw.pl \
| perl tables_w_key.pl \
| perl -wnl fantasy_lines.pl \
> $DEST_DIR/$YEAR.csv
