Bookmark
========

A command line utility for bookmarking directories and scripts. 'bookmark' allows you to store handy shortcuts to directories and scripts that you navigate to or execute frequently. 'bookmark' works by storing
a hidden file '.bookmarks' in your home directory contain your currently used bookmarks along with the directory/files to which they point. To install, simply copy the 3 files: 'mark','unmark', and 'goto', into a 
directory in your shell PATH and add the following line to your .bashrc script:
  
    alias goto='. goto'

From then on, simply navigate to a directory you wnat to bookmark and type: 

	mark myproj
to bookmark your working directory or:

    mark myproj <path to file or script>

then from anywhere in the filesystem typing:

    goto myproj

will change the working direcotry or execute the script that you bookmarked.To delete a bookmark simply type:

    unmark myproj

and the bookmark will be removed. to see the list of all available bookmarks
type:

    mark -l

There are more options available. use each command with the -h or --help option to learn more.
