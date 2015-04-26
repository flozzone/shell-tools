#!/bin/bash

# constants
doc_root="~/notes"
doc_ext=""
cmd_edit="/usr/bin/vim \$path"
cmd_view="/bin/cat \$path"
header_separator="="


doc_root_abs=$(eval "realpath $doc_root")
doc=""
has_action=false
action=false

usage() {
  echo -e "Usage: todo -e|-v document\n" >&2
  echo "Options:"
  echo "  -v        view" >&2
  echo "  -e        edit" >&2
  echo "  document  filename of file inside ~/notes" >&2
}

ask_yesno() {
  text=$1

  read -p "$text " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # do dangerous stuff
    return 0
  fi
  return 1
}

do_view() {
  path=$1
  rel_path=${path:${#doc_root_abs}+1}
  info="${prefix}${rel_path}"

  # construct the separator line
  sep=$(eval "for i in {1..${#info}} ; do echo -n \"$header_separator\" ; done")

  echo ""
  echo $info
  echo -e "$sep\n"

  eval ${cmd_view}
}

do_edit() {
  path=$1

  eval ${cmd_edit}
}

# check options
action="view"
while getopts ":ve" opt; do
  case $opt in
    v)
      action="view"
      ;;
    e)
      action="edit"
      ;;
    \?)
      echo -e "Invalid option: -$OPTARG\n" >&2
      ;;
  esac
done

# get document name parameter
doc=${@:$OPTIND:1}

path=""
exact_path="${doc_root_abs}/${doc}${doc_ext}"

# check if the document exists
if [ -f "${exact_path}" ]; then
  path=$exact_path
else
  declare find_result=($(eval "find $doc_root_abs -printf \"%p\n\" | grep $doc"))
  
  result_count=${#find_result[@]}

  if [ $result_count -eq 1 ]; then
    path=${find_result[0]}
  elif [ $result_count -eq 0 ]; then
    echo "No documents matching '$doc' found."

    if ask_yesno "Would you like to create $exact_path? (y/n)" ; then
      touch $exact_path
      path=$exact_path
      action="edit"
    else
      exit 1
    fi
  else
    echo "Document name is ambigous. Documents found:" >&2
    echo ""
    for found in ${find_result[@]} ; do
      echo "  $found"
    done
    echo ""
    exit 1
  fi 
fi

case $action in
  view)
    do_view "$path"
    ;;
  edit)
    do_edit "$path"
    ;;
  *)
    echo "Error. Should not occur"
    exit 1
    ;;
esac
