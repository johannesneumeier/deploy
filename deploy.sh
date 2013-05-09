#!/bin/sh

# v0.0.1
# author: Johannes "kontur" Neumeier
# http://johannesneumeier.com
#
# use at your own risk

# interactive dialog to create the deploy.config file 
function configDialog {
    echo "Set the default source folder path"
    read src
    if [ "$src" == "" ]; then
        echo "Source path must not be empty. Restart please. Bye, bye."
        exit
    fi

    echo "Set the destination folder path"
    read dst
    if [ "$dst" == "" ]; then
        echo "Destination path must not be empty. Restart please. Bye, bye."
        exit
    fi

    # write variables to deploy.config
    echo "SRC=\"$src\"" > deploy.config
    echo "DST=\"$dst\"" >> deploy.config

    # print ok message
    echo "Deploy script successfully configured..."
    echo "Default copy action base from "$src" to "$dst
    echo "- use -u flag to change config"
    echo "- use -r to copy in reverse direction, from "$dst" to "$src
    exit
}


# default is not reverse
REVERSE=false

# read supplied parameters
while getopts "ur" opt; do
  case $opt in
    # -u for updating the config
    u)
      configDialog
      ;;

    # check if -r was set to copy in reverse direction 
    r)
      REVERSE=true
      ;;
    # TODO implement -src -dst to update config
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done


# read the deploy.config file or create one when none exists
if [ ! -f deploy.config ]; then
    echo "No deploy.config found, want to create it now? y/n:"
    read create

    if [ $create = "y" ]; then
        configDialog
    else
        echo "Can't proceed without config, bye, bye."
        exit
    fi
else 
    . deploy.config
    echo "Reading config..."
    echo "Source folder base path: "$SRC
    echo "Destination folder base path: "$DST
fi


# what to copy to where
FROM=""
TO=""


# TODO don't know how better get $1 when -r is set
# when trying to get LOC=
if [ $REVERSE == false ]; then
    LOC=$1
    FROM=$SRC$LOC
    TO=$DST$LOC
else
    LOC=$2
    FROM=$DST$LOC
    TO=$SRC$LOC
fi


# for the destination remove anything after the last folder
# because the folder is where files should get copied to
TO=`expr "$TO" : '\(.*\/\)'`

SCP="scp -r "$FROM" "$TO
echo "Copy recursively "$FROM" -> "$TO" ? y/n:"
read confirm


if [ $confirm = "y" ]; then
    $SCP
    echo "Deployed ok, bye, bye."
else
    echo "Nothing deployed, bye, bye."
fi
