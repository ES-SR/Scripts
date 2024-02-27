#!/bin/sh
# copy all colorschemes from the HUB to the local konsole folder

# if no argument is given echo the usage
if [ -z "$1" ]; then
    echo "Usage: copyKonsoleColorschemes.sh <path_to_colorschemes>"
    exit 1
fi


# check if konsole is installed
# if not, offer to install it
if [ ! -f /usr/bin/konsole ]; then
    echo "Konsole is not installed. Do you want to install it now? (y/n)"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then # if answer begins with y or Y
	sudo apt-get install konsole
    else
	echo "Konsole is not installed. Exiting."
	exit 1
    fi
fi

# check if the folder exists
# if not, prompt the user to input the path,
# search for the folder, or exit
if [ ! -d /usr/share/konsole ]; then
  echo "Konsole colorschemes folder not found. \n \
        Automatically search for it? (s) \n \
	Manually input the path? (i) \n \
	Exit? (e)"
  read answer
  # if asked to search for the folder
  if [ "$answer" != "${answer#[Ss]}" ] ;then # if answer begins with s or S
    echo "Searching for the folder..."
    # find the folder
    foundFolder=$(find /usr -type d -name "konsole")
    # if the folder is found ask the user if he wants to use it
    if [ -d "$foundFolder" ]; then
      echo "Folder found at $foundFolder. Use it? (y/n)"
      read answer
      if [ "$answer" != "${answer#[Yy]}" ] ;then # if answer begins with y or Y
	echo "Copying files to $foundFolder..."
	sudo cp $1/*.colorscheme $foundFolder
	echo "Done."
	exit 0
      else
	echo "Exiting."
	exit 1
      fi
    else
      echo "Folder not found. Exiting."
      exit 1
    fi
  # if asked to input the path
  elif [ "$answer" != "${answer#[Ii]}" ] ;then # if answer begins with i or I
    echo "Input the path to the folder:"
    read answer
    if [ -d "$answer" ]; then
      echo "Copying files to $answer..."
      sudo cp $1/*.colorscheme $answer
      echo "Done."
      exit 0
    else
      echo "Folder not found. Exiting."
      exit 1
    fi
  # if asked to exit
  elif [ "$answer" != "${answer#[Ee]}" ] ;then # if answer begins with e or E
    echo "Exiting."
    exit 1
  fi
fi

# if the folder is found, copy the files
# and exit
echo "Copying files to /usr/share/konsole..."
sudo cp $1/*.colorscheme /usr/share/konsole
echo "Done."
exit 0



