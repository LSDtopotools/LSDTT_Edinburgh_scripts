#!/bin/bash
# This is a script for setting up LSDTopoTools for a student or researcher at the University of Edinburgh
echo =====================================================================
echo Welcome to the University of Edinburgh School of GeoSciences LSDTopoTools setup script.
echo I am going to create some directories, 
echo grab the code and data, make the programs, 
echo and in general get everything set up as painlessly as possible. 
echo Can you please enter your university user name?
echo If you get this wrong nothing will work so double check before you hit enter.

read -p "University of Edinburgh User name (UUN): " uunvar
echo Thanks $uunvar, I will now begin setting up LSDTopoTools

# Let the user decide where they want to put their stuff
echo "You can install LSDTopoTools in either your: "
echo "1) Home directory (you must do this if you are an undergraduate or taught masters student). Type yes below."
echo "2) Datashare directory (recommended for staff and research students). Type no below."
read -r -p "Do you want to install in your home directory (yes/no)? " input
case $input in
    [yY][eE][sS]|[yY])
 echo "Yes"; T_DIR="/home/$uunvar"; ynvar="yes"
 ;;
    [nN][oO]|[nN])
 echo "No"; T_DIR="/exports/csce/datastore/geos/users/$uunvar"; ynvar="no"
       ;;
    *)
 echo "Invalid input..."
 exit 1
 ;;
esac

echo "The installation directory is: "
echo $T_DIR

# Set up some directory names
HOME_DIR=$HOME
LSD_DIR="$T_DIR/LSDTopoTools"
SRC_DIR="$LSD_DIR/LSDTopoTools2/src/"
WRK_DIR="$LSD_DIR/LSDTopoTools2"
DATA_DIR="$LSD_DIR/data"
EXAMPLE_DATA_DIR="$DATA_DIR/ExampleTopoDatasets"
LINK_NAME="LSDTT_Directory"

echo Your home directory is:
echo $HOME_DIR


echo I will check for an LSDTopoTools directory here:
echo $LSD_DIR

# Make the LSDTopoTools directory if it doesn't exist
if [ -d $LSD_DIR ]
  then
    echo "LSDTopoTools directory exists!"
  else
    echo "LSDTopoTools directory doesn't exist. I'm making one"
    mkdir $LSD_DIR
fi


# Now go into the LSDTopoTools directory again
cd $LSD_DIR
echo -e "\n\n======================================="
echo "I am here: "
pwd
echo "And these files are here: "
ls 

# Get rid of the annoying symbolic link that sometimes appears for no reason whatsoever
#GETRID="LSDTopoTools"
#if [ -L $GETRID ]
#  then
#    echo "Getting rid of a stupid symbolic link that doesn't belong here!!"
#    rm LSDTopoTools
##  else
#    echo "Let me just carry on here. Don't worry about what I'm doing."
#fi


# clone or pull the repo, depending on what is in there
# check if the files have been cloned
echo -e "\n\n======================================="
echo Now let me either grab LSDTopoTools from the internet or check for updates
if [ -f $SRC_DIR/LSDRaster.cpp ]
  then
    echo "The LSDTopoTools2 repository exists, updating to the latest version."
    git --work-tree=$WRK_DIR --git-dir=$WRK_DIR.git  pull origin master
  else
    echo "Cloning the LSDTopoTools2 repository"
    git clone https://github.com/LSDtopotools/LSDTopoTools2.git $WRK_DIR
fi

# Change the working directory to that of LSDTopoTools2/src
#echo "I am going to try to build LSDTopoTools2."
cd $SRC_DIR
echo "The current directory is:"
echo $PWD
echo "Calling the build script."
sh build.sh

# Now update the path. 
# This means the computer can see where the LSDTopoTools programs are
echo -e "\n\n======================================="
echo "Now I'll add the LSDTopoTools command line programs to your path."
export PATH=$WRK_DIR/bin:$PATH
echo "Your path is now:"
echo $PATH

echo -e "\n\n======================================="
echo "Now let me check for the example data"

# Make the data directory if it doesn't exist
if [ -d $DATA_DIR ]
  then
    echo "Data directory exists!"
  else
    echo "The LSDTopoTools data directory doesn't exist. I'm making one"
    mkdir $DATA_DIR
fi

# Grab the example data
cd $DATA_DIR 
if [ "$ynvar" == "$stryes" ]
  then
    if [ -d $EXAMPLE_DATA_DIR ]
      then
        echo "The example directory exists!"
      else
        echo "Let me get the example data for you."
        echo "I am downloading the small version since you are on your home directory."
        wget https://github.com/LSDtopotools/SmallExampleTopoDatasets/archive/master.zip
        unzip master.zip
        mv ./SmallExampleTopoDatasets-master ./ExampleTopoDatasets 
        rm master.zip 
    fi
  else
    if [ -d $EXAMPLE_DATA_DIR ]
      then
        echo "The example directory exists!"
      else
        echo "Let me get the example data for you."
        echo "I'm downloading the big version since you are on the datashare."
        wget https://github.com/LSDtopotools/ExampleTopoDatasets/archive/master.zip
        unzip master.zip
        mv ./ExampleTopoDatasets-master ./ExampleTopoDatasets 
        rm master.zip 
    fi
fi

# Moving back to the LSDTT directory
cd $LSD_DIR

echo -e "\n\n======================================="
echo "Okay, I am all set up. You can start using LSDTopoTools now."
echo "Remember, you will need to run this script every time you start a new session."
echo "Please see the documentation about running your first analysis"
echo "https://lsdtopotools.github.io/LSDTT_documentation/LSDTT_basic_usage.html"

# We reset the PATH variable within this script, so we need to spawn a new bash prompt
# Otherwise, the updated PATH wil be forgotten
exec /bin/bash




