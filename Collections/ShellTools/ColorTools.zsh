#!/bin/zsh



ColorTerminalEscapeSequences () {
  declare -A ColorsTerminalEscapeSequences=(
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

  if [[ $# -eq 0 ]]; then
    for key val in ${(Vkv)ColorsTerminalEscapeSequences}; do
      echo "key: ${key} => ${val}"
      echo "${ColorsTerminalEscapeSequences[$key]} ${key} ${ColorsTerminalEscapeSequences[reset]}"
    done
    return 0
  fi

  case $1 in
    fg)
      for key val in ${(Vkv)ColorsTerminalEscapeSequences}; do
        if [[ $key == fg* ]]; then
          echo "key: ${key} => ${val}"
          echo "${ColorsTerminalEscapeSequences[$key]} ${key} ${ColorsTerminalEscapeSequences[reset]}"
        fi
      done
      return 0
      ;;
    bg)
      for key val in ${(Vkv)ColorsTerminalEscapeSequences}; do
        if [[ $key == bg* ]]; then
          echo "key: ${key} => ${val}"
          echo "${ColorsTerminalEscapeSequences[$key]} ${key} ${ColorsTerminalEscapeSequences[reset]}"
        fi
      done
      return 0
      ;;
    -h|--help)
      echo "Usage: ColorTerminalEscapeSequences [<opt>| <type>]"
      echo "  No arguments:"
      echo "    will print all escape sequences"
      echo "  Types:"
      echo "    fg - foreground color: lists all foreground color escape sequences"
      echo "    bg - background color: lists all background color escape sequences"
      echo "    attr - attribute: lists all attribute escape sequences"
      echo "  Options:"
      echo "    reset, bold, dim, underline, blink, reverse, hidden,"
      echo "    black, red, green, yellow, blue, magenta, cyan, white,"
      echo "    bgBlack, bgRed, bgGreen, bgYellow, bgBlue, bgMagenta, bgCyan, bgWhite"
      return 0
      ;;
    *)
      echo "unknown option: $arg"
      echo "run 'ColorTerminalEscapeSequences -h' for help"
      return 1
  esac

}
autoload -Uz ColorTerminalEscapeSequences


# fn:colorAdjust string:#RRGGBB string:l|d float:0-1 -> string:#RRGGBB
# Arguments:
#   $1: color to adjust (in the format #RRGGBB)
#   $2: direction to adjust (l for lighten, d for darken)
#   $3: factor to adjust by (from 0 to 1, default 0.5)
ColorAdjust () {
  for arg in $@; do
    case $arg in
      -h|--help)
        echo "Usage: ColorAdjust <color> <direction> <factor>"
        echo "Arguments:"
        echo "  color: color to adjust (in the format #RRGGBB)"
        echo "  direction: direction to adjust (l for lighten, d for darken)"
        echo "  factor: factor to adjust by (from 0 to 1, default 0.5)"
        echo "  ex. ColorAdjust #FF0000 l 0.5 -> #FF7F7F"
        return 0
        ;;
    esac
  done
  local color=$1            # color to adjust
  local direction=$2        # lighten or darken (l or d)
  local factor=${3:-0.5}  # factor to adjust by (from 0 to 1, default 0.5)
  if [[ $direction == l ]]; then
    factor=$((1 + $factor))
  elif [[ $direction == d ]]; then
    factor=$((1 - $factor))
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
  ## Variables ##
  local verbosity=0

  local -a colorsOrder=(B r g y b m c w d)
  local -A colors=(
    [B]=Black
    [r]=Red
    [g]=Green
    [y]=Yellow
    [b]=Blue
    [m]=Magenta
    [c]=Cyan
    [w]=White
    [d]=Default
    [w]=White
  )

  local -a attributesOrder=(n B u b r c)
  local -A attributes=(
    [n]=None
    [B]=Bold
    [u]=Underscore
    [b]=Blink
    [r]=Reverse
    [c]=Concealed
  )

  local -a sortOrder=(f b a)

  local fzfDisplay=0


  ## Parse Args ##
  while [[ $# -gt 0 ]]; do
    case $1 in
      -v|--verbose)
        _ve $verbosity 1 "found verbose flag"
        verbosity=1
        _ve $verbosity 1 "verbosity level set to 1"
        shift
        ;;
      -vv|--verbose2)
        _ve $verbosity 2 "found verbose2 flag"
        verbosity=2
        _ve $verbosity 2 "verbosity level set to 2"
        shift
        ;;
      -vvv|--verbose3)
        _ve $verbosity 3 "found verbose3 flag"
        verbosity=3
        _ve $verbosity 3 "verbosity level set to 3"
        shift
        ;;
      -s|--sort)
        _ve $verbosity 3 "found sort flag"
        local newSortOrder=()
        _ve $verbosity 3 "newSortOrder: $newSortOrder"
        shift
        while [[ $1 != -* ]] && [[ $# -gt 0 ]]; do
          _ve $verbosity 3 "arg: $1"
          if [[ $sortOrder[(I)$1] -gt 0 ]]; then
            _ve $verbosity 3 "adding $1 to newSortOrder"
            newSortOrder+=$1
            _ve $verbosity 3 "newSortOrder: $newSortOrder"
          else
            _ve $verbosity 1 "Unknown sort: $1"
            return 1
          fi
          shift
          _ve $verbosity 3 "shifted args"
        done
        _ve $verbosity 3 "updating sortOrder"
        sortOrder=($newSortOrder)
        ;;
      -a|--attributes)
        _ve $verbosity 3 "found attributes flag"
        local -a attributeKeys=(${(k)attributes})
        _ve $verbosity 3 "attributeKeys: $attributeKeys"
        attributesOrder=()
        _ve $verbosity 3 "attributesOrder: $attributesOrder"
        shift
        while [[ $1 != -* ]] && [[ $# -gt 0 ]]; do # while there are more args that don't start with a dash
          _ve $verbosity 3 "arg: $1"
          if [[ $attributeKeys[(I)$1] -gt 0 ]]; then  # get index and check if it is greater than 0 (arrays start at 1)
            _ve $verbosity 3 "adding $1 to attributesOrder"
            attributesOrder+=$1
            _ve $verbosity 3 "attributesOrder: $attributesOrder"
          else
            _ve $verbosity 1 "Unknown attribute: $1"
            return 1
          fi
          shift
          _ve $verbosity 3 "shifted args"
        done
        _ve $verbosity 3 "updating attributes"
        _ve $verbosity 3 "attributes keys: ${(k)attributes}"
        for key in ${(k)attributes}; do     # for each attribute in the attributes array
          if [[ $attributesOrder[(I)$key] -eq 0 ]]; then  
            _ve $verbosity 3 "removing $key from attributes"
            unset "attributes[$key]"    # unset AssociativeArray[key] removes the key from the array
            _ve $verbosity 3 "attributes: $attributes"
          fi
        done
        ;;
      -c|--colors)
        _ve $verbosity 3 "found colors flag"
        shift 1
        colorsKeys=(${(k)colors})
        _ve $verbosity 3 "colorsKeys: $colorsKeys"
        colorsOrder=()
        _ve $verbosity 3 "colorsOrder: $colorsOrder"
        while [[ $1 != -* ]] && [[ $# -gt 0 ]]; do
          _ve $verbosity 3 "arg: $1"
          if [[ $colorsKeys[(I)$1] -gt 0 ]]; then
            _ve $verbosity 3 "adding $1 to colorsOrder"
            colorsOrder+=$1
            _ve $verbosity 3 "colorsOrder: $colorsOrder"
          else
            _ve $verbosity 1 "Unknown color: $1"
            return 1
          fi
          shift
          _ve $verbosity 3 "shifted args"
        done
        _ve $verbosity 3 "updating colors"
        _ve $verbosity 3 "colors keys: ${(k)colors}"
        for key in ${(k)colors}; do
          if [[ $colorsOrder[(I)$key] -eq 0 ]]; then
            _ve $verbosity 3 "removing $key from colors"
            unset "colors[$key]"
            _ve $verbosity 3 "colors: $colors"
          fi
        done
        ;;
      -f|--fzf)
        _ve $verbosity 3 "found fzf flag"
        _ve $verbosity 2 "enabled fzf display"
        fzfDisplay=1
        shift
        ;;
      -h|--help)
        _ve $verbosity 3 "found help flag"
        echo "Usage: ColorsPrintAllShellCombos [options]"
        echo "Options:"
        echo "  -v, --verbose:"
        echo "    Enable verbosemode. More v's will increase verbosity. max 3 v's."
        echo "      -vv, --verbose2 : verbosity level 2"
        echo "      -vvv, --verbose3 : verbosity level 3"
        echo "  -a, --attributes <attributes>:"
        echo "    Set the attributes to print in the order they are passed."
        echo "    Possible args and the attributes they represent:"
        echo "      n: None, B: Bold, u: Underscore, b: Blink, r: Reverse, c: Concealed"
        echo "  -c, --colors <colors>: Set the colors to print in the order they are passed."
        echo "    Possible args and the colors they represent:"
        echo "      B: Black, r: Red, g: Green, y: Yellow, b: Blue, m: Magenta, c: Cyan, w: White, d: Default"
        echo "  -s, --sort <sort>: Set the order of the fg, bg, and attribute in the file names."
        echo "    Possible args and their meanings:"
        echo "      f: fg color, b: bg color, a: attribute"
        echo "  -f, --fzf: Use fzf to display the files."
        echo "  -h, --help: Print this help message"
        return 0
        ;;
      *)
        echo "Unknown option: $1"
        return 1
        ;;
    esac
  done
  _ve $verbosity 3 "finished parsing args"


  _ve $verbosity 1 "Setting up environment for ColorsPrintAllShellCombos"


## set alias for ls to ensure color output ##
  _ve $verbosity 2 "Checking for existing ls alias"
  local lsAlias=$(alias ls | awk -F'=' '{print $2}' | tr -d "'")
  if [[ $? -eq 0 ]]; then
    _ve $verbosity 3 "Found ls alias: $lsAlias. Saving it to restore later"
    _ve $verbosity 3 "Removing ls alias for the duration of the test"
    unalias ls
    _ve $verbosity 3 "Removed ls alias"
    _ve $verbosity 3 "ls alias: $(alias ls)"
  fi
  _ve $verbosity 2 "Creating ls alias for color test"
  alias ls='/usr/bin/ls --color=always'
  _ve $verbosity 3 "Created ls alias for color test"
  _ve $verbosity 3 "ls alias: $(alias ls)"


  ## Create tmp dir for files ##
  _ve $verbosity 2 "Creating tmp dir at /tmp/colortest.XXXXXX"
  local tmpDir=$(mktemp -d /tmp/colortest.XXXXXX)
  if [[ $? -ne 0 ]]; then
    _ve $verbosity 1 "Failed to create tmp dir"
    return 1
  fi
  _ve $verbosity 2 "Created tmp dir at $tmpDir"


  ## Create file names for PrintAllShellCombos ##
  _ve $verbosity 2 "Creating file names for color test"
  local fileNames=()
  _ve $verbosity 3 "starting fgColor loop"
  local fg_i=1
  for fgColorLetter in $colorsOrder; do
    #fileNames+=("${fg_i}_${colors[$fgColorLetter]}.FG-Color")
    _ve $verbosity 3 "starting bgColor loop"
    local bg_i=1
    for bgColorLetter in $colorsOrder; do
      #fileNames+=("${fg_i}${bg_i}_${colors[$bgColorLetter]}.BG-Color")
      _ve $verbosity 3 "starting attribute loop"
      local attr_i=1
      for attrLetter in $attributesOrder; do
        #fileNames+=("${fg_i}${bg_i}${attr_i}_${attributes[$attrLetter]}.Attribute")
        # set numberCoder by sortOrder f:fg_i b:bg_i a:attr_i
        local numberCode=""
        for s in $sortOrder; do
          case $s in
            f)
              numberCode+=$fg_i
              ;;
            b)
              numberCode+=$bg_i
              ;;
            a)
              numberCode+=$attr_i
              ;;
          esac
        done
        local fgColor=${colors[$fgColorLetter]}
        _ve $verbosity 3 "fgColor: $fgColor"
        local bgColor=${colors[$bgColorLetter]}
        _ve $verbosity 3 "bgColor: $bgColor"
        local attrName=${attributes[$attrLetter]}
        _ve $verbosity 3 "attrName: $attrName"
        local newFile="${numberCode}_${fgColor}On${bgColor}_${attrName}.${fgColorLetter}${bgColorLetter}${attrLetter}"
        _ve $verbosity 3 "newFile: $newFile"
        fileNames=($fileNames $newFile)
        _ve $verbosity 3 "fileNames: $fileNames"
        _ve $verbosity 3 "numberCode: $numberCode"
        _ve $verbosity 3 "incrementing attr_i"
        attr_i=$((attr_i + 1))
        _ve $verbosity 3 "attr_i: $attr_i"
      done
      _ve $verbosity 3 "incrementing bg_i"
      bg_i=$((bg_i + 1))
      _ve $verbosity 3 "bg_i: $bg_i"
    done
    _ve $verbosity 3 "incrementing fg_i"
    fg_i=$((fg_i + 1))
    _ve $verbosity 3 "fg_i: $fg_i"
  done
  _ve $verbosity 2 "Created file names for color test"


  ## Create files ##
  _ve $verbosity 2 "Creating files in $tmpDir from generated file names"
  for name in $fileNames; do
    _ve $verbosity 3 "Creating file: $name"
    touch $tmpDir/$name
  done
  _ve $verbosity 2 "Created files in $tmpDir"


  ## Backup LS_COLORS ##
  _ve $verbosity 2 "Creating backup of current LS_COLORS at $tmpDir/.original_dircolors"
  _ve $verbosity 3 "LS_COLORS will be restored after the test."
  _ve $verbosity 3 "In case of failure, restore them manually by running 'export LS_COLORS=\$(cat ${tmpDir}/.original_dircolors)'"
  local original_LS_COLORS=$LS_COLORS
  local original_LS_COLORS_FILE=$tmpDir/.original_dircolors
  _ve $verbosity 3 "original_LS_COLORS: $original_LS_COLORS"
  echo $original_LS_COLORS > $original_LS_COLORS_FILE
  _ve $verbosity 2 "Created backup of current LS_COLORS"


  ## Create dircolors file ##
  _ve $verbosity 3 "dircolorsFile: $tmpDir/.dircolorsFile"
  local dircolorsFile=$tmpDir/.dircolorsFile
  _ve $verbosity 2 "Creating file to load with dircolors at $dircolorsFile"
  touch $dircolorsFile
  [[ $? -ne 0 ]] && return 1
  _ve $verbosity 2 "Created file to load with dircolors"


  ## add extensions for headers ##
  _ve $verbosity 2 "Adding headers to dircolors file"
  echo "# Created by ColorsPrintAllShellCombos" >> $dircolorsFile
  echo "*.FG-Color 30;42;01;04" >> $dircolorsFile
  echo "*.BG-Color 30;44;01;04" >> $dircolorsFile
  echo "*.Attribute 30;47;01;04" >> $dircolorsFile


  ## map color and attribute flags to color codes ##
  local -A textColors=(
    [B]=30 [r]=31 [g]=32 [y]=33 [b]=34 [m]=35 [c]=36 [w]=37 [d]=39
  )
  _ve $verbosity 3 "textColors: $textColors"
  local -A bgColors=(
    [B]=40 [r]=41 [g]=42 [y]=43 [b]=44 [m]=45 [c]=46 [w]=47 [d]=49
  )
  _ve $verbosity 3 "bgColors: $bgColors"
  local -A attributes=(
    [n]=00 [B]=01 [u]=04 [b]=05 [r]=07 [c]=08
  )
  _ve $verbosity 3 "attributes: $attributes"
 

  ## Convert file name extensions to color codes ##
  _ve $verbosity 2 "Converting file names to color codes and writing to $dircolorsFile"
  for name in $fileNames; do
    # skip the headers
    if [[ $name == *.FG-Color || $name == *.BG-Color || $name == *.Attribute ]]; then
      continue
    fi
    # get the extension of the file
    local ext=$(echo $name | awk -F '.' '{print $2}' )
    _ve $verbosity 3 "ext: $ext"
     # get the color, background and attribute for the letter
    local textColor=${ext[1]}
    _ve $verbosity 3 "textColor: $textColor"
    local bgColor=${ext[2]}
    _ve $verbosity 3 "bgColor: $bgColor"
    local attr=${ext[3]}
    _ve $verbosity 3 "attr: $attr"
    local ColorCode="${textColors[$textColor]};${bgColors[$bgColor]};${attributes[$attr]}"
    _ve $verbosity 3 "ColorCode: $ColorCode"
    _ve $verbosity 3 "-------------------"
    # write the extension and color code to the dircolors file
    _ve $verbosity 3 "Writing color code $ColorCode to $dircolorsFile"
    echo "*.$ext $ColorCode" >> $dircolorsFile
  done
  _ve $verbosity 2 "Wrote color codes to $dircolorsFile"
  
 
  ## set LS_COLORS with dircolors and dircolors file ##
  _ve $verbosity 2 "Setting LS_COLORS with dircolors and $dircolorsFile"
  eval $(dircolors -b $dircolorsFile)
  _ve $verbosity 2 "Set LS_COLORS with dircolors and $dircolorsFile"
  _ve $verbosity 3 "LS_COLORS: $LS_COLORS"

  ## Display files with colored output ##
  _ve $verbosity 1 "Finished setting up environment for ColorsPrintAllShellCombos"
  _ve $verbosity 1 "Displaying files with colored output"
  _ve $verbosity 3 "checking ls alias"
  if [[ $fzfDisplay -eq 0 ]]; then
    _ve $verbosity 2 "Displaying files with colored output"
    eval ls $tmpDir
  else
    _ve $verbosity 2 "Displaying files with fzf interface"
    eval ls $tmpDir | fzf --ansi --reverse --multi --marker="🗹" --pointer="➢" --color="dark,bg+:-1:regular,fg+:-1:regular,marker:green"
  fi


  ## Cleanup ##
  _ve $verbosity 1 "Cleaning up after ColorsPrintAllShellCombos"
  _ve $verbosity 2 "Unsetting script's ls alias"
  unalias ls
  _ve $verbosity 3 "Checking for original ls alias"
  if [[ -n $lsAlias ]]; then
    _ve $verbosity 2 "Restoring original ls alias"
    alias ls=$lsAlias
    _ve $verbosity 3 "Restored ls alias"
  fi

  _ve $verbosity 2 "Restoring original LS_COLORS"
  export LS_COLORS=$(cat $tmpDir/.original_dircolors)
  _ve $verbosity 3 "Restored original LS_COLORS"

  _ve $verbosity 2 "Removing dircolors file"
  rm -rf $tmpDir
  _ve $verbosity 3 "Removed dircolors file"


  _ve $verbosity 2 "Finished cleaning up after ColorsPrintAllShellCombos"
  return 0
} 
autoload -Uz ColorsPrintAllShellCombos



_verbosityCheck () {
# fn:_verbosityCheck int:verbosityLevel int:levelRequired -> int:0|1 => 0 meets requirements, 1 does not
  # ex: _verbosityCheck 2 1 -> 0  :  _verbosityCheck 2 1 && echo "this will print"
  # ex: _verbosityCheck 1 2 -> 1  :  _verbosityCheck 1 2 && echo "this will not print"
  
  local verbose=$1
  local levelCheck=$2

  if [[ $verbose -ge $levelCheck ]]; then
    return 0
  else
    return 1
  fi
}
_vc=_verbosityCheck # alias for _verbosityCheck

_verboseEcho () {
# fn:_verboseEcho int:verbosityLevel int:levelRequired string:message -> void => echo message if verbosityLevel meets levelRequired
  # ex: _verboseEcho 2 1 "this will print" -> "this will print"
  # ex: _verboseEcho 1 2 "this will not print" -> 
  # ex: _verboseEcho 2 2 "var: $var" -> "var: value of var"

  local verbosity=$1
  local levelCheck=$2
  
  if _verbosityCheck $verbosity $levelCheck; then
    shift 2
    echo $@
  fi
}
_ve () {
  _verboseEcho $@
}

