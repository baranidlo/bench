#!/usr/bin/env bash

JUGGLERFILE="http://lists.starwarsclubhouse.com/api/v1/tournaments"
JUGGLERFOLDER="http://lists.starwarsclubhouse.com/api/v1/tournament/"

# Move old tournaments file to tournaments.old
if [ -e tournaments ];
then
	echo "Moving old 'tournaments' to 'tournaments.old'..."
	mv tournaments tournaments.old
else
	echo "ERROR: 'tournaments' file not found!"
	exit 1
fi

# Grab new tournament data
if [ ! -e tournaments ];
then
	echo "Downloading new 'tournaments' file..."
	wget ${JUGGLERFILE} -O "tournaments"
else
	echo "ERROR: new 'tournaments' would overwrite old file; aborting!"
	exit 2
fi

# Run python diff script
if [ -e tournaments ];
then
	echo "Downloading new tournament list data..."
	for FILE in `./diff_tournaments.py "tournament.old" "tournament"`; do
		wget ${JUGGLERFOLDER}${FILE} -O ${FILE}
	done
else
	echo "ERROR: Could not find new 'tournaments' file!"
	exit 3
fi
exit 0
