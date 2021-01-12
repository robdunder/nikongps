#!/bin/bash
# nikon_gps_download.sh

# Download web page
DLPAGEURL=http://nikonimglib.com/agps2/index.html.en

# SD card destination directory
DESTDIR='/Volumes/NIKON D5300/NIKON'

# Unique string in the download link
# As of 2014-07-06 the URL is crossgate.nikonimglib.com so look for "crossgate"
DLURLMATCH="crossgate"

#echo "DL Page = " $DLPAGEURL
#echo "DL Match = " $DLURLMATCH

# Create a temporary file to hold the initial download page
TMPFILE=`mktemp -t nikon_dl` || exit 1
echo "program output"  $TMPFILE

# Get the download page and find the download URL
curl -Lk $DLPAGEURL -o $TMPFILE || exit 1
REGEX="http.://.*?$DLURLMATCH.*?\\\""
DLFILEURL=`egrep -o $REGEX $TMPFILE | sed -E 's/\"//'`
#echo "DL File = "$DLFILEURL

# Execute the download and save in the ~/Downloads directory
# TODO: find how to get this name automatically from the server
DLFILE=NML_28A.ee
curl -Lk $DLFILEURL -o "$HOME/Downloads/$DLFILE" || exit 1

# Copy the GPS assist file to the SD card
if [ ! -d "$DESTDIR" ]
then
    echo Creating "$DESTDIR"
    mkdir "$DESTDIR" || exit 1
fi
if [ -e "$DESTDIR/$DLFILE" ]
then
    echo Replacing:
    echo " " `shasum "$DESTDIR/$DLFILE"`
    echo " " `ls -l "$DESTDIR/$DLFILE"`
    echo With:
    echo " " `shasum $HOME/Downloads/$DLFILE`
    echo " " `ls -l $HOME/Downloads/$DLFILE`
fi
cp $HOME/Downloads/$DLFILE "$DESTDIR" || exit 1

# Clean up
rm $TMPFILE
