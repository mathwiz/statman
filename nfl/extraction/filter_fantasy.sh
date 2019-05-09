#!/bin/bash

SRC_DIR=/Users/yohanlee/Cloud/Data/Nfl/fantasy/cleaned
DEST_DIR=/Users/yohanlee/Cloud/Data/Nfl/fantasy/filtered
YEAR=$1

cat $SRC_DIR/$YEAR.csv \
| perl -wnl position_present.pl \
> $DEST_DIR/$YEAR.csv
