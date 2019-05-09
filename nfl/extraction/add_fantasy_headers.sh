#!/bin/bash

DATA_DIR=/Users/yohanlee/Dev/Github/statman/nfl/extraction
SRC_DIR=/Users/yohanlee/Cloud/Data/Nfl/fantasy/filtered
DEST_DIR=/Users/yohanlee/Cloud/Data/Nfl/fantasy/augmented


cat $DATA_DIR/headers_fantasy.csv $SRC_DIR/*.csv \
> $DEST_DIR/fantasy_all.csv
