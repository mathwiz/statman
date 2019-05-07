#!/bin/bash

DEST_DIR=/Users/yohanlee/Cloud/Data/Nfl/teams/raw
YEAR=$1
URL=`perl url_season.pl -season=$YEAR`

echo $URL \
| perl doget.pl \
> $DEST_DIR/$YEAR.html
