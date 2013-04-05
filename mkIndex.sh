#!/bin/bash

mdHead="<html><head><link href="http://notes.joshgordon.net/style.css" rel="stylesheet"></link><title>Directory Listing</title></head><body>" 

mdFoot="<body></html>" 


################################################################################
function gen
{ 

    #get the directory listing
    dirList=`ls`

    #echo $mdHead > index.md

    #loop over each file/directory and add it to the index. 

    for file in $dirList; do 
	if [ -d $file ]; then 
	    cd $file
	    gen
	    echo "* [$file]($file)" #>> index.md
	else
	    htmlFile=`echo $file | sed -e "s/\.md$/.html/"` 
	    baseName=${file%%.*} 
	    echo "* [$baseName]($htmlFile)" #>>index.md
	fi

    done
} 

gen
