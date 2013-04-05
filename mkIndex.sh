#!/bin/bash

mdHead="<html><head><link href="http://notes.joshgordon.net/style.css" rel="stylesheet"></link><title>Directory Listing</title></head><body>" 

mdFoot="</body></html>" 

#patterns to exclude. Anything grep matches will handle this. 
exclude="index" 

################################################################################
function gen
{ 

    #get the directory listing
    dirList=`ls`

    echo $mdHead > index.md
    echo >> index.md

    echo \# ${PWD##*/} >> index.md
    echo >> index.md

    #loop over each file/directory and add it to the index. 

    for file in $dirList; do 
	if [ -d $file ]; then 
	    echo "* [$file]($file)" >> index.md
	    cd $file
	    gen
	    cd .. 
	else
	    #check for excluded files: 
	    if !(echo $file | grep $exclude > /dev/null); then
		htmlFile=`echo $file | sed -e "s/\.md$/.html/"` 
		baseName=${file%%.*} 
		echo "* [$baseName]($htmlFile)" >>index.md
	    fi
	fi

    done
    
    echo $mdFoot >> index.md
} 

gen
