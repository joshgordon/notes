#!/bin/bash

mdHead="<html><head><link href="http://notes.joshgordon.net/style.css" rel="stylesheet"></link><title>"

mdHead2="</title></head><body>" 

mdFoot="</body></html>" 

#patterns to exclude. Anything grep matches will handle this. 
exclude="index Makefile mkIndex style html README.md" 

################################################################################

rootDir=`pwd`
function gen
{ 
    if [ -f README.md ]; then
	if (head -n 1 README.md | grep "#"); then 
	    title=`head -n 1 README.md | sed -e 's/#* //'`
	elif (head -n 2 README.md | tail -n 1 | grep "="); then
	    title=`head -n 1 README.md`
	else
	    title=`echo ${PWD##*/} | sed 's/.*/\L&/; s/[[:graph:]]*/\u&/g'` 
	fi

    fi
    

    #get the directory listing
    dirList=`ls`

    #title
    echo $mdHead $title $mdHead2 > index.md

    #title as H1
    echo \#  $title >> index.md
    
    echo -n "[root](/) > " >> index.md

    structure=`pwd | sed -e "s#^$rootDir##; s#/# #g"` 
    curPath="" 
    for folder in $structure; do 
	curPath=$curPath/$folder
	echo -n "[$folder]($curPath) > " >> index.md
    done
    
    echo >> index.md
    echo >> index.md


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
		if (echo $file | grep "$exclusion" > /dev/null); then
		    include=false
		    echo $exclusion :: $file
		fi
	    done 
	    if $include; then
	    	htmlFile=`echo $file | sed -e "s/\.md$/.html/"` 
		baseName=${file%%.*} 
		echo "* [$baseName]($htmlFile)" >>index.md
	    fi
	fi

    done

    if [ -f README.md ]; then
	echo >> index.md
	if (head -n 1 README.md | grep "#"); then 
	    tail -n +2 README.md >> index.md
	elif (head -n 2 README.md | tail -n 1 | grep "="); then
	    tail -n +3 README.md >> index.md
	else
	    cat README.md >> index.md
	fi
	echo >> index.md
    fi
    
    echo $mdFoot >> index.md
} 

gen
