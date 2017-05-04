VERSION=$(shell cat VERSION)
NAME=vocab-$(VERSION)
JAR=target/$(NAME).jar
RES=src/test/resources
HTML=html
DIST=target/vocab

help:
	@echo
	@echo "Available goals are:"
	@echo
	@echo "      clean : Clean removes all artifacts from previous builds."
	@echo "        jar : Creates the vocab-$(VERSION).jar file."
	@echo "    install : Copies the jar and startup script to the user's bin directory."
	@echo "    release : Zips the executable and templates."
	@echo "     upload : uploads the zip files to the ANC web server."
	@echo "       help : Displays this help message."
	@echo
	
jar:
	mvn package
	
clean:
	mvn clean
	
install:
	cp $(JAR) $(HOME)/bin
	cat $(RES)/vocab | sed 's|__JAR__|vocab-$(VERSION).jar|' > $(HOME)/bin/vocab
	cp $(JAR) ../../Lappsgrid/vocab/bin
	cp $(HOME)/bin/vocab ../../Lappsgrid/vocab/bin
	
debug:
	@echo "Current version is $(VERSION)"
	
release:
	#mvn clean package
	if [ ! -f $(JAR) ] ; then mvn clean package ; fi
	if [ -d $(DIST) ] ; then rm -rf $(DIST) ; fi
	if [ -f target/$(NAME).zip ] ; then rm target/$(NAME).zip ; fi
	if [ -f target/vocab-latest.zip ] ; then rm target/vocab-latest.zip ; fi

	mkdir $(DIST)
	cat $(RES)/vocab | sed 's|__JAR__|vocab-$(VERSION).jar|' > $(DIST)/vocab
	chmod u+x $(DIST)/vocab
	#cp $(RES)/lapps.vocab $(DIST)
	#cp $(RES)/*.groovy $(DIST)
	#cp -r $(HTML) $(DIST)
	cp $(JAR) $(DIST)
	cd target ; zip -r vocab vocab ; cp vocab.zip $(NAME).zip ; mv vocab.zip vocab-latest.zip
	echo "Release ready."
	
upload:
	if [ -e target/$(NAME).zip ] ; then scp -P 22022 target/$(NAME).zip suderman@anc.org:/home/www/anc/downloads ; fi
	if [ -e target/vocab-latest.zip ] ; then scp -P 22022 target/vocab-latest.zip suderman@anc.org:/home/www/anc/downloads ; fi
	echo "Upload complete."

