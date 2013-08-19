Bookmark
========

A command line utility for bookmarking directories. 'bookmark' works by storing
a hidden file '.bookmarks' in your home directory contain all your currently used
bookmarks. To install, simply copy the 3 files: mark,unmark, and goto into a 
directory in your shell PATH and add the following line:
  
    alias goto='. goto'

to your .bashrc script. From then on, to mark a directory simply type:

     mark myproj ~/directory1/directory2/.../directoryN

then from anywhere in the filesystem typing:

    goto myproj

will change the working direcotry to the directory you bookmarked. To delete
a bookmark simply type:

    unmark myproj

and the bookmark will be removed. to see the list of all available bookmarks
type:

    mark -l

Other options are available. use the -h option to learn more about the 
command.
