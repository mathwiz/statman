#!/bin/bash

DEST_DIR=/Users/yohanlee/Cloud/Data/Nfl/fantasy/raw
YEAR=$1
URL=`perl url_fantasy_big.pl -season=$YEAR`

echo $URL \
| perl doget.pl \
> $DEST_DIR/$YEAR.html
