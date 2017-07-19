INSTALL_DIR=~/.bashmarks

all:
	@echo "Please run 'make install'"

install:
	@echo ""
	mkdir -p $(INSTALL_DIR)
	cp bashmarks.sh $(INSTALL_DIR)
	@echo ""
	@echo "Please add 'source $(INSTALL_DIR)/bashmarks.sh' to your .bashrc file"
	@echo ''
	@echo 'USAGE:'
	@echo '------'
	@echo 'bs <bookmark_name> - Saves the current directory as "bookmark_name"'
	@echo 'bg <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"'
	@echo 'bp <bookmark_name> - Prints the directory associated with "bookmark_name"'
	@echo 'bd <bookmark_name> - Deletes the bookmark'
	@echo 'bl                 - Lists all available bookmarks'

.PHONY: all install
