#!/bin/zsh


declare -gA ColorsTerminalEscapeSequences=(
  [reset]=$'\e[0m'
  [bold]=$'\e[1m'
  [dim]=$'\e[2m'
  [underline]=$'\e[4m'
  [blink]=$'\e[5m'
  [reverse]=$'\e[7m'
  [hidden]=$'\e[8m'
  [black]=$'\e[30m'
  [red]=$'\e[31m'
  [green]=$'\e[32m'
  [yellow]=$'\e[33m'
  [blue]=$'\e[34m'
  [magenta]=$'\e[35m'
  [cyan]=$'\e[36m'
  [white]=$'\e[37m'
  [bgBlack]=$'\e[40m'
  [bgRed]=$'\e[41m'
  [bgGreen]=$'\e[42m'
  [bgYellow]=$'\e[43m'
  [bgBlue]=$'\e[44m'
  [bgMagenta]=$'\e[45m'
  [bgCyan]=$'\e[46m'
  [bgWhite]=$'\e[47m'
)


# fn:colorAdjust string:#RRGGBB string:l|d float:0-1 -> string:#RRGGBB
# Arguments:
#   $1: color to adjust (in the format #RRGGBB)
#   $2: direction to adjust (l for lighten, d for darken)
#   $3: factor to adjust by (from 0 to 1, default 0.5)
ColorAdjust () {
  local color=$1            # color to adjust
  local direction=$2        # lighten or darken (l or d)
  local factor=${3:-0.5}  # factor to adjust by (from 0 to 1, default 0.5)
  if [[ $direction == l ]]; then
          factor=$((1 + $factor))
  fi

  local r g b               
  # separate RGB values
    # 0x is used to interpret the string as a hex number
    # printf '%d' is used to convert the hex number to a decimal number
    # color:<start>:<length> is used to slice the string
  r=$(printf '%d' 0x${color:1:2})
  g=$(printf '%d' 0x${color:3:2})
  b=$(printf '%d' 0x${color:5:2})

  r=$((r * factor))
  g=$((g * factor))
  b=$((b * factor))
  # ensure that the values are within the valid range
  [[ $r -gt 255 ]] && r=255 
  [[ $r -lt 0 ]] && r=0
  [[ $g -gt 255 ]] && g=255
  [[ $g -lt 0 ]] && g=0
  [[ $b -gt 255 ]] && b=255
  [[ $b -lt 0 ]] && b=0

  r=$(printf '%02x' $r)
  g=$(printf '%02x' $g)
  b=$(printf '%02x' $b)
  
  echo "#$r$g$b"
}
autoload -Uz ColorAdjust


ColorsPrintAllShellCombos () {
  local verbose=0
  for arg in $@; do
    if [[ $arg == -v ]] || [[ $arg == --verbose ]]; then
      verbose=1
    fi
  done

  local -a colorsOrder=(B r g y b m c w d)
  local -a attributesOrder=(n B u b r c)
  local -A colors=(
    [B]=Black [r]=Red [g]=Green [y]=Yellow [b]=Blue [m]=Magenta [c]=Cyan [w]=White [d]=Default [w]=White
  )
  local -A attributes=(
    [n]=None [B]=Bold [u]=Underscore [b]=Blink [r]=Reverse [c]=Concealed
  )

  [[ $verbose -eq 1 ]] && echo "Starting color test"
 
  local lsAlias=$(alias ls | awk -F'=' '{print $2}' | tr -d "'")
  if [[ $? -eq 0 ]]; then
    [[ $verbose -eq 1 ]] && echo "Found ls alias: $lsAlias. Saving it to restore later"
    [[ $verbose -eq 1 ]] && echo "Removing ls alias for the duration of the test"
    unalias ls
    [[ $verbose -eq 1 ]] && echo "Removed ls alias"
  fi
  [[ $verbose -eq 1 ]] && echo "Creating ls alias for color test"
  alias ls='ls --color=always'
  [[ $verbose -eq 1 ]] && echo "Created ls alias for color test"


  [[ $verbose -eq 1 ]] && echo "Creating tmp dir for color test at /tmp/colortest.XXXXXX"
  local tmpDir=$(mktemp -d /tmp/colortest.XXXXXX)
  if [[ $? -ne 0 ]]; then
    [[ $verbose -eq 1 ]] && echo "Failed to create tmp dir"
    return 1
  fi
  [[ $verbose -eq 1 ]] && echo "Created tmp dir at $tmpDir"

  [[ $verbose -eq 1 ]] && echo "Creating file names for color test"
  local fileNames=()
  for fgColorLetter in $colorsOrder; do
    for bgColorLetter in $colorsOrder; do
      for attrLetter in $attributesOrder; do
        local fgColor=${colors[$fgColorLetter]}
        local bgColor=${colors[$bgColorLetter]}
        local attrName=${attributes[$attrLetter]}
        local newFile="${fgColor}On${bgColor}_${attrName}.${fgColorLetter}${bgColorLetter}${attrLetter}"
        [[ verbose -eq 1 ]] && echo "Creating file name: $newFile"
        fileNames=($fileNames $newFile)
      done
    done
  done
  [[ $verbose -eq 1 ]] && echo "Created file names for color test"

  [[ $verbose -eq 1 ]] && echo "Creating color test files in $tmpDir"
  for name in $fileNames; do
    touch $tmpDir/$name
  done
  [[ $verbose -eq 1 ]] && echo "Created color test files in $tmpDir"

  if [[ $verbose -eq 1 ]]; then
    echo "Creating backup of current LS_COLORS"
    echo "Current settings will be saved to $tmpDir/.original_dircolors"
    echo "They will be restored after the test. In case of failure, restore them manually"
    echo "by running 'export LS_COLORS=\$(cat ${tmpDir}/.original_dircolors)'"
  fi
  local original_LS_COLORS=$LS_COLORS
  local original_LS_COLORS_FILE=$tmpDir/.original_dircolors
  echo $original_LS_COLORS > $original_LS_COLORS_FILE
  [[ $verbose -eq 1 ]] && echo "Created backup of current LS_COLORS"


  [[ $verbose -eq 1 ]] && echo "Creating file to load with dircolors"
  local dircolorsFile=$tmpDir/.dircolorsFile
  touch $dircolorsFile
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
  for name in $fileNames; do
    # get the extension of the file
    local ext=$(echo $name | awk -F '.' '{print $2}' )
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
    echo "*.$ext $ColorCode" >> $dircolorsFile
  done
  [[ $verbose -eq 1 ]] && echo "Wrote color codes to $dircolorsFile"
  
  [[ $verbose -eq 1 ]] && echo "Loading color codes with dircolors"
  eval $(dircolors -b $dircolorsFile)

  [[ $verbose -eq 1 ]] && echo "Printing color test files"
  eval ls $tmpDir



  [[ $verbose -eq 1 ]] && echo "unsetting script's ls alias"
  unalias ls
  [[ $verbose -eq 1 ]] && echo "unset ls alias"
  if [[ -n $lsAlias ]]; then
    [[ $verbose -eq 1 ]] && echo "Restoring original ls alias"
    alias ls=$lsAlias
    [[ $verbose -eq 1 ]] && echo "Restored ls alias"
  fi

  [[ $verbose -eq 1 ]] && echo "Restoring original LS_COLORS"
  export LS_COLORS=$(cat $tmpDir/.original_dircolors)
  [[ $verbose -eq 1 ]] && echo "Restored original LS_COLORS"

  [[ $verbose -eq 1 ]] && echo "Removing tmp dir"
  rm -rf $tmpDir
  [[ $verbose -eq 1 ]] && echo "Removed tmp dir"

  [[ $verbose -eq 1 ]] && echo "Done"
  return 0
} 
autoload -Uz ColorsPrintAllShellCombos
