#!/bin/bash

# volume check

VOL_PATH=/var/lib/mysql

old_IFS=$IFS
IFS=$'\n' # to ensure space-in-names are treated correctly in for loop
# actually Bluemix console (GUI) does not allow you to have whitespaces in volume names

vol_path=$(mount | grep nfs4 | cut -d\  -f3)
found=0

for i in $vol_path
do
	i=${i%/} # delete trailing slash
	[[ "$i" == "$VOL_PATH" ]] && found=1
done

IFS=${old_IFS}

if [ $found == 0 ]
then
	echo "ERROR: Volume is not mounted on $VOL_PATH"
	echo "Start your container again with $VOL_PATH mounted"
	exit 2
fi

echo "Volume is properly mounted."
