# arguments
LISTNAME=$1
OUT=$2
TITLE=$3

# constants
DB=openwhyd_dump
COLUMNS="Week,Code 0,Code 100,Code 150,Timeout,Video playback error,Unrecognized track,Bad key"
FIELDS="_id,value.0,value.100,value.150,value.timeout,value.video_playback_error,value.unrecognized_track,value.bad key"

echo "exporting $LISTNAME mongodb collection to $OUT.temp.csv ..."
echo $COLUMNS >$OUT.temp.csv
mongoexport -d $DB -c "$LISTNAME" --type=csv --fields "$FIELDS" | tail -n+2 >>$OUT.temp.csv
./csv-helpers/fill-empty-values.sh $OUT.temp.csv 0

echo "plot data to ../plots/$OUT.png ..."
mkdir ../plots &>/dev/null
gnuplot -c plot-row-stacked-histogram.gp $OUT.temp.csv "$TITLE" >../plots/$OUT.png

echo "open ../plots/$OUT.png ..."
open ../plots/$OUT.png
# rm $OUT.temp.csv
