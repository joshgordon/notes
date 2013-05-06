build : 
	./mkIndex.sh 
	find . -iname "*.md" -exec ./make_markdown.sh {} \; 

clean : 
	find . -iname "*.html" -exec rm {} \; 
	find . -iname "index.md" -exec rm {} \; 
