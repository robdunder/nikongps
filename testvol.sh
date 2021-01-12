#!/bin/bash

ls -l /Volumes/NIKON\ D5300/

if [ -d /Volumes/NIKON\ D5300/ ]
then
    echo "Nikon D5300 SD card present"
    /Users/rob/bin/nikon_gps_download.sh
else
    echo "Nikon SD card NOT present"
fi
