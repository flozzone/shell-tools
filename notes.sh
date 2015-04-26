#!/bin/bash

doc_root="~/notes"
extension="txt"
cmd_edit="/usr/bin/vim"
cmd_view="/bin/cat"
cmd_new="/usr/bin/vim"
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

do_view() {
  path=$1
  rel_path=${path:${#doc_root_abs}+1}
  info="${prefix}${rel_path}"
  sep=$(eval "for i in {1..${#info}} ; do echo -n \"$header_separator\" ; done")
  #echo $sep
  echo ""
  echo $info
  echo -e "$sep\n"

  exec ${cmd_view} ${path}
}

do_edit() {
  path=$1

  exec ${cmd_edit} ${path}
}

do_new() {
  path=$1

  exec ${cmd_new} ${path}
}


# check options
while getopts ":ve" opt; do
  case $opt in
    v)
      has_action=true
      action="view"
      ;;
    e)
      has_action=true
      action="edit"
      ;;
    \?)
      echo -e "Invalid option: -$OPTARG\n" >&2
      ;;
  esac
done

if ! $has_action ; then
  usage
  exit 1
fi

doc=${@:$OPTIND:1}

path=""
exact_path="${doc_root_abs}/${doc}.${extension}"

if [ -f "${exact_path}" ]; then
  path=$exact_path
else
  declare find_result=($(eval "find $doc_root_abs -printf \"%p\n\" | grep $doc"))
  
  if [ ${#find_result[@]} -eq 1 ]; then
    path=${find_result[0]}
  else
    echo "Document name is ambigous. Documents found:" >&2
    echo ""
    for found in ${find_result[@]} ; do
      echo "  $found"
    done
    echo ""
    path=""
  fi 
fi

if [ -z "${path}" ]; then
    echo "Could not find any document with '${doc}'." >&2
    exit 1
fi

case $action in
  view)
    do_view "$path"
    ;;
  edit)
    do_edit "$path"
    ;;
  new)
    do_new "$path"
    ;;
  *)
    echo "Error. Should not occur"
    exit 1
    ;;
esac
