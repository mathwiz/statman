#!/bin/bash

SRC_DIR=/Users/yohanlee/Cloud/Data/Nfl/fantasy/augmented
DEST_DIR=/Users/yohanlee/Cloud/Data/Nfl/fantasy/augmented
FILE=fantasy_all.csv
OUT=fantasy_aug.csv

python ./augment_dk.py $SRC_DIR/$FILE $DEST_DIR/$OUT 
