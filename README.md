Bookmark
========

A command line utility for bookmarking directories and scripts. 'bookmark' allows you to store handy shortcuts to directories and scripts that you navigate to or execute frequently. 'bookmark' works by storing
a hidden file '.bookmarks' in your home directory contain your currently used bookmarks along with the directory/files to which they point. To install, simply copy the 'bookmark' file into a persistent directory and add the following line to your .bashrc script:
  
    alias goto='. goto'
    source /path/to/bookmark

From then on, simply navigate to a directory you want to bookmark and type: 

	mark myproj
to bookmark your working directory or:

    mark myproj <path to file or script>

then from anywhere in the filesystem typing:

    go myproj

will change the working direcotry or execute the script that you bookmarked. To delete a bookmark simply type:

    unmark myproj

and the bookmark will be removed. to see the list of all available bookmarks
type:

    mark -l

Autocompletion is supported, so pressing 
	
	go abc [tab]

will list all the avaialble bookmarks starting with the letters "abc". If there is only one matching bookmark, the script will automatically complete the full bookmark name into the command line.

There are more options available. use each command with the -h or --help option to learn more.
