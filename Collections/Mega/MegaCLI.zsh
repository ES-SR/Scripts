#!/usr/local/bin/zsh

# helper functions for MegaCMD

function mg () {
# mg <cmd> [<args>] => mega-<cmd> [<args>]
#  mg is easier than mega- to type 
#  with no cmd, lists the command options

  if [[ ! -z $1 ]]; then
    mega-$1 ${@:2}
    return $?
  else
    #echo "mega- commands:"
    local cmds=(attr backup cancel cat cd cmd cmd-server confirm cp debug )
    cmds+=(deleteversions df du errorcode exclude exec export find ftp )
    cmds+=(get graphics help https import invite ipc killsession lcd log )
    cmds+=(login logout lpwd ls mediainfo mkdir mount mv passwd permissions )
    cmds+=(preview proxy put pwd quit reload rm session share showpcr )
    cmds+=(signup speedlimit sync thumbnail transfers tree userattr users )
    cmds+=( version webdav whoami )

    # mega- prepended to each command
    local megaCmds=()
    for cmd in $cmds; do
      megaCmds+="mega-$cmd"
    done

   local selectedCmd=$(
     echo $megaCmds |  \
      tr ' ' '\n' |  \
       fzf --ansi --cycle --track --no-mouse --scroll-off=5 --tabstop=2 --reverse \
         --pointer="->" \
         --preview="{} --help" --preview-window="down:50%,wrap,cycle"
   )

    $selectedCmd
  fi
}
autoload -Uz mg
