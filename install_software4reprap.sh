#!/bin/bash

# This is free software. No warranty provided. Use it on your own responsability.
# Copyright 2012, GPL v3.
# Author: Jose Antonio Quevedo <joseantonio.quevedo@gmail.com>
# Based on the source code published: http://reprap.org/wiki/Printrun.


# This script gets from the internet and install the software needed to use a reprap printer.
# Goal: Install or update a reprap station only using this script and a internet connection.

# Usage: No arguments required. Just run: install_software4reprap.sh
# You don't need to be root to use this script.

# Nowadays installing:
# Tools:
# - Printrun
# - Skeinforge 
# - Arduino v22.
# - Slic3r
# - Cura
# Firmwares:
# - Sprinter super stable.
# - Sprinter
# - Marlin
# - Teacup

# Tested on Debian GNU/Linux 7.0 beta 4.

# Known bugs: 
# - Arduino v22 is an old version of Arduino IDE. Used to compile Sprinter Super Stable. It doesn't work properly on the last version of Debian GNU/Linux or other updated systems. Due to incompatibility with avr library.
# +info: http://forums.reprap.org/read.php?146,150086,164546,quote=1
# - Slicer's last version doesn't works on Debian yet. By now they are working on an RC buggy version of libc. This could take come time.

#TODO: - Add more software, like Slic3r, Cura.
#      - Firmwares: Teacup.
#      - 
#      - Improve update functionality.

set -x

##########
# CONFIGURATION

BASEDIR="$HOME/bin" # Where everything is installed.
PRINTRUNDIR="$BASEDIR/Printrun" # 'Printrun' directory.
SKEINFORGEDIR="$PRINTRUNDIR/skeinforge" #'Skeinforge' directory, located within the 'Printrun' directory.

SKEINFORGE_URL=http://fabmetheus.crsndoo.com/files
SKEINFORGE_FILENAME=50_reprap_python_beanshell.zip

# URLs $ Filenames
PRINTRUN_GIT_URL=https://github.com/kliment/Printrun.git

ARDUINO_URL=http://arduino.googlecode.com/files
ARDUINO_32bits_FILENAME=arduino-0022.tgz
ARDUINO_64bits_FILENAME=arduino-0022-64-2.tgz
# Default
ARDUINO_FILENAME=$ARDUINO_32bits_FILENAME

CURA_URL=http://software.ultimaker.com/current
CURA_FILENAME=Cura-12.10-linux.tar.gz

SLICER_URL=http://dl.slic3r.org/linux
SLICER_32bits_FILENAME=slic3r-linux-x86-0-9-7.tar.gz
SLICER_64bits_FILENAME=slic3r-linux-x86_64-0-9-7.tar.gz

# # Old Slicer urls
# SLICER_URL=http://dl.slic3r.org/linux/old
# SLICER_64bits_OLD_FILENAME=slic3r-linux-x86_64-0-8-4.tar.gz
# SLICER_64bits_FILENAME=$SLICER_64bits_OLD_FILENAME

# Default
SLICER_FILENAME=$SLICER_32bits_FILENAME


# END OF CONFIGURATION.
############

# Configuring download urls depending on the kernel version.
KERNEL=$(uname -r)
echo "Kernel version detected: $KERNEL"
(uname -r | grep amd64 > /dev/null) && ARDUINO_FILENAME=$ARDUINO_64bits_FILENAME && SLICER_FILENAME=$SLICER_64bits_FILENAME

DATE=$(date +"%Y%m%d%H%M")

pressEnter(){
    echo -n "Press any key to continue."
    read
}

# Clean: Removes a tmp file
# $1: the name of the file stored in tmp.
function clean(){
    echo "Cleaning up temporary installation files..."
    rm -f /tmp/$1
}

# Check for dependencies.
# Thanks for: http://www.snabelb.net/content/bash_support_function_check_dependencies
checkDependencies(){

    CURA_DEPS="python-opengl"
    THIS_SCRIPT_DEPS="git unzip"
    DEPENDENCIES="$THIS_SCRIPT_DEPS $CURA_DEPS"
 
    deps_ok=YES
    for dep in $DEPENDENCIES; do
  if ! dpkg -l | grep $dep &>/dev/null;  then
            echo -e "This script requires $dep to run but it is not installed"
            echo -e "If you are running ubuntu or debian you might be able to install $dep with the following command"
            echo -e "\t\tsudo apt-get install $dep\n"
            deps_ok=NO
	fi
    done
    # Python 2.6 required to load files using Pronterface, for skeinforge?
    PYTHON26_DIR_DIST_PACKAGES=/usr/lib/python2.6/dist-packages/
    [ -d $PYTHON26_DIR_DIST_PACKAGES ] || {
	echo "No existe el directorio $PYTHON26_DIR_DIST_PACKAGES"
	echo "Necesita tener instalado Python 2.6. Saliendo."
	exit 1
    }
    if [[ "$deps_ok" == "NO" ]]; then
        echo -e "Unmet dependencies ^"
        echo -e "Aborting!"
        exit 1
    else
        return 0
    fi

    

}

# Renombra el directorio recibido por argumento añadiendo una marca de tiempo al nombre.
backupDir(){

    dir2backup=$1
    rc=0

    if [ -d $dir2backup ]; then
	echo -n "Creating backup of $dir2backup."

	mv $dir2backup $dir2backup-$DATE || rc=1
	[ $rc -eq 0 ] && echo "DONE." \
	    || echo "ERROR creating backup for $dir2backup."

    fi;
    return $rc
}

# Install/update Printrun
installPrintrun(){
    dirbase=$1
    printrunDir=$2
  # Printrun
  if [ -d $printrunDir/.git/ ]; then
      echo "Updating Printrun"
      cd $printrunDir
      git pull #|| exit 1
      cd -
  else
      mkdir -p $dirbase
      cd $dirbase
      echo "Installing Printrun"
      git clone $PRINTRUN_GIT_URL
      cd -
  fi
}

#main(){

  checkDependencies || exit 1

## Next call to backupDir is commonly used for testing purpose.
## This script expected behaviour should be to update the existing software. Not to replace it again and again, so.. Default: Disabled.
## Uncomment the next line to rename $BASEDIR before installing anything.
#  backupDir $BASEDIR || exit 1

  ## Tools

  # Printrun
  installPrintrun $BASEDIR $PRINTRUNDIR

  #Skeinforge
  URL_MAIN=$SKEINFORGE_URL
  FILENAME=$SKEINFORGE_FILENAME
  echo "Grabbing skeinforge from $URL_MAIN/$FILENAME"
  [ -f /tmp/$FILENAME ] || wget -P /tmp $URL_MAIN/$FILENAME
  mkdir -p $SKEINFORGEDIR
  echo "Unzipping skeinforge into Printrun directory..."
  unzip -d $SKEINFORGEDIR /tmp/$FILENAME > /dev/null || clean "$FILENAME"
  ln -s $SKEINFORGEDIR/* $PRINTRUNDIR/
  echo "Es necesario crear un enlace para que funcione Pronterface con Skeinforge. Introduzca password de root:"
  su root - -c "ln -s $SKEINFORGEDIR /usr/lib/python2.6/dist-packages/skeinforge"

  # Arduino 22
  URL_MAIN=$ARDUINO_URL
  FILENAME=$ARDUINO_FILENAME
#  echo "Instalando Arduino."
  [ -f /tmp/$FILENAME ] || wget -P /tmp $URL_MAIN/$FILENAME
  tar -xzf /tmp/$FILENAME -C $BASEDIR || clean "$FILENAME"

  # Cura
  URL_MAIN=$CURA_URL
  FILENAME=$CURA_FILENAME
  [ -f /tmp/$FILENAME ] || wget -P /tmp $URL_MAIN/$FILENAME
  tar -xzf /tmp/$FILENAME -C $BASEDIR || clean "$FILENAME"

  # Slicer
  URL_MAIN=$SLICER_URL
  FILENAME=$SLICER_FILENAME
  [ -f /tmp/$FILENAME ] || wget -P /tmp $URL_MAIN/$FILENAME
  tar -xzf /tmp/$FILENAME -C $BASEDIR || clean "$FILENAME"
  
  ## Firmwares

  mkdir -p $BASEDIR/Firmwares
  cd $BASEDIR/Firmwares

  # Sprinter SuperStable
  SPRINTER_SS_URL=http://www.iearobotics.com/downloads/2012-08-31-R2-Reloaded
  SPRINTER_SS_FILENAME=R2-Reloaded-Sprinter-Superestable-0.2.zip
  wget -c $SPRINTER_SS_URL/$SPRINTER_SS_FILENAME && \
      mkdir SprinterSuperStable && \
      unzip -d SprinterSuperStable $SPRINTER_SS_FILENAME
  # Sprinter
  [ -d ./Sprinter/.git ] && (cd Sprinter; git pull; cd - >/dev/null) || git clone https://github.com/kliment/Sprinter.git
  # Marlin
  [ -d ./Marlin/.git ] && (cd Marlin; git pull; cd - >/dev/null) || git clone https://github.com/ErikZalm/Marlin
  # Teacup
  [ -d ./Teacup_Firmware/.git ] && (cd Marlin; git pull; cd - >/dev/null) || git clone https://github.com/triffid/Teacup_Firmware.git

  exit 0

#}
