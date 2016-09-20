CMP_FILE=wiki-notes.tar.gz
CMP_FILES=.env config.ru Gemfile gollum-server wiki-notes.sublime-workspace wiki-notes.sublime-project

all: serve

dist:
	tar --exclude .DS_Store* -czvf ${CMP_FILE} $(CMP_FILES)

serve:
	./gollum-server stop
	./gollum-server start
