### Bashmarks is a shell script that allows you to save and jump to commonly used directories. Now supports tab completion.

## Install

1. git clone git://github.com/miroslavvidovic/bashmarks.git
2. cd bashmarks
3. make install
4. source **~/.local/bin/bashmarks.sh** from within your **~.bash\_profile** or **~/.bashrc** file

## Shell Commands

    bs <bookmark_name> - Saves the current directory as "bookmark_name"
    bg <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"
    bp <bookmark_name> - Prints the directory associated with "bookmark_name"
    db <bookmark_name> - Deletes the bookmark
    bl                 - Lists all available bookmarks
    
## Example Usage

    $ cd /var/www/
    $ bs webfolder
    $ cd /usr/local/lib/
    $ bs locallib
    $ bl
    $ bg web<tab>
    $ bg webfolder

## Where Bashmarks are stored
    
All of your directory bookmarks are saved in a file called ".sdirs" in your HOME directory.
