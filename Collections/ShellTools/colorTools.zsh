#!/bin/zsh

# tools for terminal colors

colorAdjust () {
    local color=$1	    # color to adjust
    local direction=$2	    # lighten or darken (l or d)
    local factor=${3:-0.5}  # factor to adjust by (from 0 to 1, default 0.5)
    if [[ $direction == 'l' ]]; then
	factor=$((1 + factor))
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
autoload -Uz colorAdjust

declare -gA ColorsArray=(
  [black]=#000000
  [white]=#ffffff
  [red]=#ff2600
  [orange]=#ff5f00
  [yellow]=#ffff00
  [green]=#5fff00
  [blue]=#5fafff
  [indigo]=#5f5fff
  [violet]=#af5fff
  [cyan]=#5fffff
  [magenta]=#ff5fff
)
