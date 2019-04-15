#!/bin/bash

findString() {
    ($1 logs -f $4 $5 $6 $7 $8 $9 2>&1 | grep -m $3 "$2" &) | grep -m $3 "$2" > /dev/null
}

echo "Waiting startup..."
findString $1 "ready for connections" 1 $2 $3 $4 $5 $6 $7
$1 logs $2 $3 $4 $5 2>&1 | grep -q "Initializing database"
if [ $? -eq 0 ] ; then
	echo "Almost there..."
	findString $1 "ready for connections" 2 $2 $3 $4 $5 $6 $7
fi
echo "Server is up!"

