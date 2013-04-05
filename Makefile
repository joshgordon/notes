build : 
	./mkIndex.sh 
	find . -iname "*.md" -exec md {} \; 

clean : 
	find . -iname "*.html" -exec rm {} \; 
	find . -iname "index.md" -exec rm {} \; 
