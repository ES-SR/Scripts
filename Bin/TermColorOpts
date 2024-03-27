#!/bin/zsh


# prints all text attributes for all text colors on all backgrounds

# attributes:
# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
# colors:
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white 39=default
# backgrounds:
# 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white 49=default
# * default is the terminal default color.
# * bold is often a brighter version of the same color.
# * reverse may display text as the background color and vice-versa.
# * concealed may hide the text (useful for passwords).
# * blink may not work on all terminals, or implementations may vary.
# * underscore is often interpreted as italics.
# ** basically test it out on your terminal to see what works and what doesn't, 
# ** thats what this script is for.

# create file suffixes for each attribute
# fist letter is for text color, second for background color, third for attributes
#  ie nbr = none blue red
#  as black and blue both begin with b, a capital 'B' is used for Black
#  and a lowercase 'b' for blue
#  attributes bold and blink will use the same solution.
#  'B' for bold and 'b' for blink

# attributes:
# n=none B=bold u=underscore b=blink r=reverse c=concealed
# colors (text and background):
# B=Black r=red g=green y=yellow b=blue m=magenta c=cyan w=white d=default

# create a tmp dir with files for each combination of attributes, colors and backgrounds
# this script will first permutate text, then background, then attributes
#  ie BBn, rBn, gBn,... Brn, rrn, ... , ... , BBB, rBB,... and so on

function createTmpDir {
# if -v or --verbose is passed, echo the current step
local verbose=0
if [[ $1 == "-v" || $1 == "--verbose" ]]; then
  verbose=1
  echo "Creating tmp dir for color test at /tmp/colortest"
fi
  local tmpDir=$(mktemp -d /tmp/colortest.XXXXXX)
  

  # test dir made and return 0 for success or 1 for failure
  # along with message if verbose is set
  if [[ -d $tmpDir ]]; then
    if [[ $verbose -eq 1 ]]; then
      echo "Tmp dir created successfully"
    fi
    echo $tmpDir
    return 0
  else
    if [[ $verbose -eq 1 ]]; then
      echo "Tmp dir creation failed"
    fi
    return 1
  fi
}

function createFileNames {
# creates an array of all possible file names
#  ie BlackOnBlack_None.BBn RedOnBlack_None.rBn ...
local verbose=0
if [[ $1 == "-v" || $1 == "--verbose" ]]; then
  verbose=1
  echo "Creating file names"
fi

## TODO: accept colors and attributes as arguments to createFileNames ##

  local -a colorsOrder=(B r g y b m c w d)
  local -a attributesOrder=(n B u b r c)
  #local -a attributesOrder=(n B u)
  local -A colors=(
    [B]=Black [r]=Red [g]=Green [y]=Yellow [b]=Blue [m]=Magenta [c]=Cyan [w]=White [d]=Default [w]=White
  )
  #local -A attributes=(
  #  [n]=None [B]=Bold [u]=Underscore
  #)
  local -A attributes=(
    [n]=None [B]=Bold [u]=Underscore [b]=Blink [r]=Reverse [c]=Concealed
  )
  local files=()

  if [[ verbose -eq 1 ]]; then
    echo "Creating file names from:"
    echo "Colors: ${colors[@]}"
    echo "and"
    echo "Attributes: ${attributes[@]}"
  fi

  for fgColorLetter in $colorsOrder; do
    for bgColorLetter in $colorsOrder; do
      for attrLetter in $attributesOrder; do
        local fgColor=${colors[$fgColorLetter]}
	local bgColor=${colors[$bgColorLetter]}
	local attrName=${attributes[$attrLetter]}
	local newFile="${fgColor}On${bgColor}_${attrName}.${fgColorLetter}${bgColorLetter}${attrLetter}"
	if [[ verbose -eq 1 ]]; then
	  echo "Creating file name: $newFile"
	fi
	files=($files $newFile)
      done
    done
  done

  if [[ verbose -eq 1 ]]; then
    echo "File names created."
  fi

  # return the array of file names
  echo $files
}

function createFiles {
# creates files in the tmp dir with the names passed in the array
# utilizing the previously defined functions

  # create tmp dir
  local tmpDir=$(createTmpDir $1)
  if [[ $? -eq 1 ]]; then
    echo "Failed to create tmp dir"
    return 1
  fi

  # create file names
  local files=($(createFileNames $1))
  if [[ $? -eq 1 ]]; then
    echo "Failed to create file names"
    return 1
  fi

  # create files
  if [[ $1 == "-v" || $1 == "--verbose" ]]; then
    echo "Creating files for color test"
  fi

  for file in $files; do
    touch $tmpDir/$file
  done

  if [[ $1 == "-v" || $1 == "--verbose" ]]; then
    echo "Files created"
  fi

  # echo dir, files for use in other functions
  echo $tmpDir
  echo $files
  return 0
}


function printTmpDir {
# prints the contents of the tmp dir using ls -l to show the colors
#  and attributes set in $LS_COLORS
  local tmpDir=$1
  if [[ ! -d $tmpDir ]]; then
    echo "Directory $tmpDir does not exist"
    return 1
  fi


  # print the results of ls -l in the tmp dir to stdout
  ls $tmpDir

  return 0
}

function createTmpDircolorsAndLs {
# creates a dircolors file in tmp dir mapping each file type to
# the appropriate combination of attributes, colors and backgrounds
#   ie .BBn=00;30;40 .rBn=00;31;40 ...

  local verbose=0
  if [[ $1 == "-v" || $1 == "--verbose" ]]; then
    verbose=1
    echo "Creating dircolors file for color test"
  fi

  # call createFiles to get the tmp dir, and files
  local dirAndFiles=($(createFiles))
  if [[ $? -eq 1 ]]; then
    echo "Failed to create tmp dir and files"
    return 1
  fi

  # split the return value of createFiles into the tmp dir and files
  #  dir is the first element, files is the rest
  local tmpDir=$dirAndFiles[1]
  local files=($dirAndFiles[2,-1])

  # create the dircolors file, after storing the current LS_COLORS value in a variable
  # to restore it after the test
  local currentLS_COLORS=$LS_COLORS
  echo $currentLS_COLORS > $tmpDir/.original-LS_COLORS
	
  local dircolorsFile=$tmpDir/dircolors
  touch $dircolorsFile

  # map each file to the appropriate color, background and attributes
  local -A textColors=(
    [B]=30 [r]=31 [g]=32 [y]=33 [b]=34 [m]=35 [c]=36 [w]=37 [d]=39
  )
  local -A bgColors=(
    [B]=40 [r]=41 [g]=42 [y]=43 [b]=44 [m]=45 [c]=46 [w]=47 [d]=49
  )
  local -A attributes=(
    [n]=00 [B]=01 [u]=04 [b]=05 [r]=07 [c]=08
  )

  # now for each file in files array, write the extension and color code to the dircolors file
  for file in $files; do
    # get the extension of the file
    local ext=$(echo $file | awk -F '.' '{print $2}' )
    # get each letter of the extension

    # get the color, background and attribute for the letter
    local textColor=${ext[1]}
    local bgColor=${ext[2]}
    local attr=${ext[3]}

    local ColorCode="${textColors[$textColor]};${bgColors[$bgColor]};${attributes[$attr]}"

   if [[ $verbose -eq 1 ]]; then

      echo "" $ext " - " $ColorCode
      echo "-------------------"
      echo "fg:   " ${ext[1]} ":" ${textColors[$textColor]}
      echo "bg:   " ${ext[2]} ":" ${bgColors[$bgColor]}
      echo "attr: " ${ext[3]} ":" ${attributes[$attr]}
      echo ""

    fi
    # write the extension and color code to the dircolors file
    echo ".$ext $ColorCode" >> $dircolorsFile
    
  done

  # use dircolors command to set the LS_COLORS variable to the
  # dircolors file created
  eval $(dircolors $dircolorsFile)

  # call the function to print the contents of the tmp dir using ls -l
  # and the new LS_COLORS value
  printTmpDir $tmpDir

  allTermColorOptionsCleanup $tmpDir
  return 0
}

function allTermColorOptionsCleanup {
# restore the original LS_COLORS value,
# remove the tmp dir and all files in it
# unset functions, vars, etc
  local tmpDir=$1

  # testing 
  #echo "LS_COLORS before cleanup"
  #echo $LS_COLORS

  # export the original LS_COLORS value
  #export LS_COLORS=$(cat $tmpDir/.original-LS_COLORS)


  # testing
  #echo "LS_COLORS after cleanup"
  #echo $LS_COLORS

  rm -rf $tmpDir
  #unset -f createTmpDir createFileNames createFiles printTmpDir createTmpDircolorsAndLs allTermColorOptionsCleanup
  #unset tmpDir originalLS_COLORS
  return 0
}


function PrintTermColorOptions {
# prints all text attributes for all text colors on all backgrounds
  createTmpDircolorsAndLs
}

autoload -Uz  PrintTermColorOptions
