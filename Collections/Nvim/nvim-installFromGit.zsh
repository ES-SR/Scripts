#/bin/zsh


# install nvim from git repo

function nvimCloneRepo {
  [[ $# -lt 1 ]] && \
	  echo "pass dir where repo should be cloned" && \
	  return 1
  # $1 is local dir
  git clone https://github.com/neovim/neovim $1 && \
	  echo $1
}


function nvimInstallPrerequisites {
	# check for installed gcc ver. 4.9+ or clang
	#  -> install if not found
	local compiler=""
	local compiler_version=""
	
	$compiler=$(command -v gcc)
	[[ -z $compiler ]] &&  \
	  $compiler=$(command -v clang)

	[[ -z $compiler ]] && \
	  # install either compiler

	[[ ! -z $compiler ]] && \
	  $compiler_version=($compiler --version)

	# check version is ok 
	#  -> update if not
	
	# check cmake ver. 3.13+ installed
	#  -> install/update if not

	#check platform	
	# platform based requirements
	# ubuntu/deb
	#  -> sudo apt-get install ninja-build gettext cmake unzip curl build-essential
	# RHEL/Fedora
	#  -> sudo dnf -y install ninja-build cmake gcc make unzip gettext curl glibc-gconv-extra
	# OpenSUSE
	#  -> sudo zypper install ninja cmake gcc-c++ gettext-tools curl
	# Arch
	#  -> sudo pacman -S base-devel cmake unzip ninja curl
	# Alpine
	#  -> apk add build-base cmake coreutils curl unzip gettext-tiny-dev
	# Void
	#  -> xbps-install base-devel cmake curl git
	# FreeBSD
	#  -> sudo pkg install cmake gmake sha unzip wget gettext curl
	# OpenBSD
	#  -> doas pkg_add gmake cmake unzip curl gettext-tools
}


function nvimMake {
	# $1 is local nvim repo
	# $2 is release ver  (stable, ..)

	
	# cd into local repo
	
	# git checkout release version
	
	# make CMAKE_BUILD_TYPE=RelWithDebInfo 
}

function nvimMakeInstall {
	# $1 is custom instal location default to <local repo>
	# make cmake_install_prefix=/full/path/ install
	make CMAKE_INSTALL_PREFIX=${HOME}/Store/Repos/nvim install
}

function nvimModifyZshrc {
	# add nvim bin dir to path
	
}
