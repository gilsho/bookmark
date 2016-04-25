#! /bin/sh

bookmark_mark_help_message() {
  echo "usage: mark [-h] [-f] [-e] bookmark [location]"
  echo ""
  echo "bookmark locations for easy retrival"
  echo ""
  echo "positional arguments:"
  echo "  bookmark  a name of the bookmark"
  echo "  location  a directory of file to bookmark"
  echo ""
  echo "optional arguments:"
  echo "-h, --help  show this help message and return"
  echo "-f      forces overwrite of an existing bookmark"
  echo "-l      lists all the current bookmarks"
  echo ""
  echo "see also: unmark, goto"
}

bookmark_unmark_help_message() {
  echo "usage: unmark [-h] bookmark"
  echo ""
  echo "remove a bookmarked location created using the 'mark' command"
  echo ""
  echo "positional arguments:"
  echo "  bookmark  a name of the bookmark to remove"
  echo ""
  echo "optional arguments:"
  echo "-h, --help  show this help message and return"
  echo ""
  echo "see also: mark, goto"
}

bookmark_goto_help_message() {
  echo "usage: goto [-h] bookmark"
  echo ""
  echo "navigate to a bookmarked location created using the 'mark' command"
  echo ""
  echo "positional arguments:"
  echo "  bookmark  a name of the bookmark to navigate to or execute"
  echo ""
  echo "optional arguments:"
  echo "-h, --help  show this help message and return"
  echo ""
  echo "see also: mark, unmark"
}

bookmark_list_bookmarks() {
  if [ -f ~/.bookmarks ]; then
    while read line
    do
      local split
      # split line into array, with colon character as delimiter
      IFS=":" read -r -a split <<< "$line"
      local saved_mark="${split[0]}"
      local location="${split[1]}"
      echo -e "$saved_mark" "\t->\t" "$location"
    done < ~/.bookmarks
  fi
}

mark() {
  # parse options
  local f_flag=false
  local l_flag=false

  while [ $# -gt 0 ]
  do
      case "$1" in
        (-f) f_flag=true;;
        (-l) l_flag=true;;
        (-h) bookmark_mark_help_message; return 0;;
        (--help) bookmark_mark_help_message; return 0;;
        (-*) echo "$0: error - unrecognized option $1" 1>&2; return 1;;
        (*)  break;;
      esac
      shift
  done

  # if list option selected, list bookmarks list existing bookmarks
  if [[ $l_flag = true ]]; then
    bookmark_list_bookmarks
    return 0
  fi

  # parse arguments
  if [[ "$#" == "0" ]]; then
    echo "error: you must supply a name for the bookmark" 1>&2
    return 1
  fi

  local new_mark="$1"
  shift

  # extract full path of bookmark location
  if [[ "$#" == "0" ]]; then
    local location=$(pwd)
  else
    if [[ -d "$1" ]]; then
      local location="$(cd "$1"; pwd)"
    else
      # resolve full path to file
      local location=$(python -c "import os; print os.path.abspath(\"$1\")")
    fi
    shift
  fi

  if  (($# > 0)); then
    echo "error: too many arguments" 1>&2;
    return 1
  fi


  marks=()
  if [ -f ~/.bookmarks ]; then
    while read line
    do
      local split
      # split line into array, with colon character as delimiter
      IFS=":" read -r -a split <<< "$line"
      local saved_mark="${split[0]}"
      if [ "$saved_mark" = "$new_mark" ]; then
        if [  $f_flag = false ]; then
          echo "error: bookmark '$new_mark' already used." 1>&2
          return 1
        fi
      else
        marks+=("$line")
      fi
    done < ~/.bookmarks
  fi

  local marks=("${marks[@]}" "$new_mark:$location")

  rm -rf ~/.bookmarks
  touch ~/.bookmarks
  for mark in "${marks[@]}"; do
    echo "$mark" >> ~/.bookmarks
  done

}

unmark() {
  # parse options
  local a_flag=false
  while [ $# -gt 0 ]
  do
      case "$1" in
        (-h) bookmark_unmark_help_message; return 0;;
        (-a) a_flag=true;;
        (--help) bookmark_unmark_help_message; return 0;;
        (-*) echo "$0: error - unrecognized option $1" 1>&2; return 1;;
        (*)  break;;
      esac
      shift
  done

  if [ "$#" == "0" -a $a_flag = false ]; then
    echo "error: you must supply a name for the bookmark" 1>&2; return 1;
  fi

  # parse arguments
  local new_mark="$1"
  shift

  if  (($# > 0)); then
    echo "error: too many arguments" 1>&2; return 1;
  fi

  # accumulate all bookmarks other than one selected for removal
  local marks=()
  if [ -f ~/.bookmarks ]; then
    while read line
    do
      local split
      # split line into array, with colon character as delimiter
      IFS=":" read -r -a split <<< "$line"
      local saved_mark="${split[0]}"
      if [ ! "$saved_mark" = "$new_mark" -a "$a_flag" = false ]; then
        marks+=("$line")
      fi
    done < ~/.bookmarks
  fi

  # replace old bookmark file with new contents
  rm -rf ~/.bookmarks
  touch ~/.bookmarks
  for mark in "${marks[@]}"; do
    echo "$mark" >> ~/.bookmarks
  done
}

goto() {
  # Parse options
  while [ $# -gt 0 ]
  do
      case "$1" in
        (-h) bookmark_goto_help_message; return 0;;
        (--help) bookmark_goto_help_message; return 0;;
        (-*) echo "$0: error - unrecognized option $1" 1>&2; return 1;;
        (*)  break;;
      esac
      shift
  done

  # Parse arguments
  if [[ "$#" == "0" ]]; then
    echo "error: you must supply a name for the bookmark" 1>&2; return 1;
  elif (( $# > 1)); then
    echo "error: too many arguments" 1>&2; return 1;
  else
    local mark="$1"
    shift
  fi

  # search for bookmark
  local marks=()
  local found=false
  if [ -f ~/.bookmarks ]; then
    while read line
    do
      local split
      # split line into array, with colon character as delimiter
      IFS=":" read -r -a split <<< "$line"
      local saved_mark="${split[0]}"
      local location="${split[1]}"
      if [ "$saved_mark" = "$mark" ]; then
        if [ -d "$location" ]; then
          cd "$location";
          found=true
        elif [ -f "$location" ]; then
          "$location";
          found=true
        else
          echo "error: invalid bookmark" 1>&2;
          found=true
        fi
        break;
      fi
    done < ~/.bookmarks
  fi

  if [ $found = false ]; then
    echo "error: bookmark not found" 1>&2
  fi
}


bookmark_list() {
  local list=""
  while read line
  do
    local split
    # split line into array, with colon character as delimiter
    IFS=":" read -r -a split <<< "$line"
    local saved_mark="${split[0]}"
    local list="$saved_mark"" ""$list"
  done < ~/.bookmarks
  echo "$list"
}

bookmark_autocomplete()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    local marklist=$( bookmark_list )
    COMPREPLY=( $(compgen -W "$marklist" -- $cur) )
}

complete -F bookmark_autocomplete mark
complete -F bookmark_autocomplete unmark
complete -F bookmark_autocomplete go
