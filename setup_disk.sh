#!/bin/sh

cd ~/grokit/src/Tool_DataPath/executable
touch ~/grokit/disk

./dp -be QUAN <<EOF
0
1
1
EOF

exit 0
