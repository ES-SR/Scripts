#!/usr/bin/zsh

# replace characters in filenames within a directory

# usage: ./replace <directory> <replace> <with> [file pattern ...]
# example: ./replace /path/to/dir " " "_" "*.txt"
# example: ./replace /path/to/dir " " "_" "*.txt" "*.md"
#
# note: if no file pattern is provided, all files in the directory will be processed

# get the directory by prepending the current directory if the directory is not an absolute path
dir=$1
if [[ $dir != /* ]]; then
  dir=$(pwd)/$dir
fi
echo "dir: $dir"

# get the replace string
replace=$2
echo "replace: $replace"

# get the with string
with=$3
echo "with: $with"

patterns="*"
if [ $# -gt 3 ]; then
  # get the file patterns
  patterns=${@:4}
fi
echo "patterns: $patterns"


# replace characters in filenames
# for each file in the directory filtered by the file patterns
# use zsh pattern matching to filter the files
setopt extended_glob null_glob # enable zsh pattern matching
files=($dir/$~patterns)
unsetopt extended_glob null_glob # disable zsh pattern matching
for file in $files; do

  # create the new filename by replacing the characters while handling special characters
  # if replace is a special character, use the following syntax
  # newfile=$(echo $file | sed "s/\$replace/$with/g")
  # if with is a special character, use the following syntax
  # newfile=$(echo $file | sed "s/$replace/\$with/g")
  # if both replace and with are special characters, use the following syntax
  # newfile=$(echo $file | sed "s/\$replace/\$with/g")
  # if neither replace nor with are special characters, use the following syntax
  # newfile=$(echo $file | sed "s/$replace/$with/g")
  # check replace and with for special characters
  # if replace is a special character change the value of replace to the escaped value
  for special in "\$" "^" "." "*" "+" "?" "{" "}" "(" ")" "|" "[" "]"; do
    if [[ $replace == *$special* ]]; then
      replace=$(echo $replace | sed "s/$special/\\$special/g")
    fi
  done
  # if with is a special character change the value of with to the escaped value
  for special in "\$" "^" "." "*" "+" "?" "{" "}" "(" ")" "|" "[" "]"; do
    if [[ $with == *$special* ]]; then
      with=$(echo $with | sed "s/$special/\\$special/g")
    fi
  done

  # create the new filename
  newfile=$(echo $file | sed "s/$replace/$with/g")
  echo "newfile: $newfile"

  # if the new filename already exists, skip the file
  if [ -e $newfile ]; then
    echo "newfile already exists, skipping"
    continue		##TODO: add flags for overwriting, skipping, etc.
  fi

  # if the new filename is different from the old filename, rename the file
  if [ "$file" != "$newfile" ]; then
    echo "renaming $file to $newfile"
    mv $file $newfile
  fi
done

echo "done"
ls $dir | grep $patterns





