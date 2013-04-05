#!/bin/bash

mdHead="<html><head><link href="http://notes.joshgordon.net/style.css" rel="stylesheet"></link><title>"

mdHead2="</title></head><body>" 

mdFoot="</body></html>" 

#patterns to exclude. Anything grep matches will handle this. 
exclude="index Makefile mkindex style" 

################################################################################
function gen
{ 

    title=${PWD##*/} | sed 's/.*/\L&/; s/[[:graph:]]*/\u&/g'
    #get the directory listing
    dirList=`ls`

    echo $mdHead $title $mdHead2 > index.md
    # echo $title >> index.md
    # echo $mdHead2 >> index.md

    echo \#  $title >> index.md
#    echo >> index.md

    #loop over each file/directory and add it to the index. 

    for file in $dirList; do 
	if [ -d $file ]; then 
	    echo "* [$file]($file)" >> index.md
	    cd $file
	    gen
	    cd .. 
	else
	    
	    include=true 
	
            #check for excluded files: 
	    for exclusion in $exclude; do 
		if !(echo $file | grep "$exclusion" > /dev/null); then
		    include=false
		fi
	    done 
	    if $include; then
	    	htmlFile=`echo $file | sed -e "s/\.md$/.html/"` 
		baseName=${file%%.*} 
		echo "* [$baseName]($htmlFile)" >>index.md
	    fi
	fi

    done
    
    echo $mdFoot >> index.md
} 

gen
