build : 
	./mkIndex.sh 
	find . -iname "*.md" -exec ./make_markdown {} \; 

clean : 
	find . -iname "*.html" -exec rm {} \; 
	find . -iname "index.md" -exec rm {} \; 
