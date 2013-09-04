#!/bin/bash

mdHead="<html><head><link href="http://notes.joshgordon.net/style.css" rel="stylesheet"></link><title>"

mdHead2="</title></head><body>" 

mdFoot="</body></html>" 

#patterns to exclude. Anything grep matches will handle this. 
exclude="index Makefile mkIndex style html README.md make_markdown.sh favicon.ico" 

################################################################################
rootDir=`pwd`
rootTitle="" 
folderNames=""

#Find the name of the topmost directory for use in the paths. 
if [ -f README.md ]; then
    if (head -n 1 README.md | grep "#"); then 
	rootTitle=`head -n 1 README.md | sed -e 's/#* //'`
    elif (head -n 2 README.md | tail -n 1 | grep "="); then
	rootTitle=`head -n 1 README.md`
    else
	rootTitle=`echo ${PWD##*/} | sed 's/.*/\L&/; s/[[:graph:]]*/\u&/g'` 
    fi

fi


function gen
{ 
    #Find the title by either using the first line (if it's H1) of Readme or
    #by looking at the dirname. 
    if [ -f README.md ]; then
	if (head -n 1 README.md | grep "#"); then 
	    title=`head -n 1 README.md | sed -e 's/#* //'`
	elif (head -n 2 README.md | tail -n 1 | grep "="); then
	    title=`head -n 1 README.md`
	else
	    title=`echo ${PWD##*/} | sed 's/.*/\L&/; s/[[:graph:]]*/\u&/g'` 
	fi
    else
	title=`echo ${PWD##*/} | sed 's/.*/\L&/; s/[[:graph:]]*/\u&/g'` 
    fi

    #get the directory listing
    dirList=`ls`

    #title
    echo $mdHead $title $mdHead2 > index.md

    #title as H1
    echo \#  $title >> index.md
    
    #Start the path bar. 
    echo -n "[$rootTitle](/) > " >> index.md
    
    
    structure=`pwd | sed -e "s#^$rootDir##; s#/# #g"` 
    curPath="" 
    for folder in $structure; do 
	curPath=$curPath/$folder

	dirName=$folder

	#Look at the readme files and get the titles for the path tree. 
	if [ -f $rootDir$curPath/README.md ]; then
	    echo BANG
	    if (head -n 1 $rootDir$curPath/README.md | grep "#"); then 
		dirName=`head -n 1 $rootDir$curPath/README.md | sed -e 's/#* //'`
	    elif (head -n 2 $rootDir$curPath/README.md | tail -n 1 | grep "="); then
		dirName=`head -n 1 $rootDir$curPath/README.md`
	    fi
	fi

	echo -n "[$dirName]($curPath) > " >> index.md
    done
    
    echo >> index.md
    echo >> index.md


    #loop over each file/directory and add it to the index. 

    for file in $dirList; do 


################################################################################
       #If  this is a folder instaed of a file. 
	if [ -d $file ]; then 

	    folderName=$file
	    #Look at the readme files and get the titles for the path tree. 
	    if [ -f $folderName/README.md ]; then
		if (head -n 1 $folderName/README.md | grep "#" 2> /dev/null); then 
		    folderName=`head -n 1 $folderName/README.md | sed -e 's/#* //'`
		elif (head -n 2 $folderName/README.md | tail -n 1 | grep "=" 2> /dev/null); then
		    folderName=`head -n 1 $folderName/README.md`
		fi
	    fi
	    
	    echo "* [$folderName]($file)" >> index.md
	    cd $file
	    gen
	    cd .. 

################################################################################
	#If it's a file. 
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
