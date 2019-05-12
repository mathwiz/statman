#!/bin/bash

SRC_DIR=/Users/yohanlee/Cloud/Data/Nfl/fantasy/augmented/
DEST_DIR=/Users/yohanlee/Cloud/Data/Nfl/fantasy/augmented/
SRC_FILE=augmented_all.csv


cat $SRC_DIR/$SRC_FILE \
| perl -wnl filter_qb.pl \
> $DEST_DIR/qb.csv

cat $SRC_DIR/$SRC_FILE \
| perl -wnl filter_rb.pl \
> $DEST_DIR/rb.csv

cat $SRC_DIR/$SRC_FILE \
| perl -wnl filter_wr.pl \
> $DEST_DIR/wr.csv

cat $SRC_DIR/$SRC_FILE \
| perl -wnl filter_te.pl \
> $DEST_DIR/te.csv
