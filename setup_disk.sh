#!/bin/sh

cd ~/grokit/src/Tool_DataPath/executable
touch ~/grokit/disk

# Prevent vagrant stopping
sh -c "./dp -e | true"

exit 0
