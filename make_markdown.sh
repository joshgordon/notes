#!/bin/bash
if test -n "$1"; then 
    if test -r $1; then 
	infile=$1
	outfile=`echo $infile | sed -e "s/\.md$/.html/"` 
	if (Markdown.pl "$infile" > "$outfile"); then
	    echo $outfile written successfully. 
	fi
	
    else
	echo Input file does not exist. 
    fi
    
else
    echo Markdown conversion
    echo USAGE: $0 {filename.md}
    
fi
