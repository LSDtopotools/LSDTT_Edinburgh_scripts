#!/bin/bash
# This is a script for setting up LSDTopoTools for a student or researcher at the University of Edinburgh
echo =====================================================================
echo Welcome to the LSDTopoTools setup script for native Linux users.
echo I am going to create some directories, 
echo grab the code and data, make the programs, 
echo and in general get everything set up as painlessly as possible. 
echo =====================================================================
echo First things first, you need to tell me the directory
echo within which you wish to install LSDTopoTools. 
echo The script will create an LSDTopoTools directory within the directory you name
echo The directory must already exist!

read -p "Please enter the directory where you want to install LSDTopoTools: " T_DIR
echo Thanks, I will install LSDTopoTools in the directory $T_DIR

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

cd $HOME_DIR
# Make a symbolic link to that directory if it doesn't exist
echo "I am now going to make a symbolic link to the LSDTopoTools directory"
if [ -f $LINK_NAME ]
  then
    echo "You already have a symbolic link to the LSDTopoTools directory"
  else
    echo -e "\n\n======================================="
    echo "I am going to make a symbolic link to the LSDTopoTools directory here."
    ln -s $LSD_DIR $LINK_NAME
fi


# Now go into the LSDTopoTools directory again
cd $LSD_DIR
echo -e "\n\n======================================="
echo "I am here: "
pwd
echo "And these files are here: "
ls 

# Get rid of the annoying symbolic link that sometimes appears for no reason whatsoever
GETRID="LSDTopoTools"
if [ -L $GETRID ]
  then
    echo "Getting rid of a stupid symbolic link that doesn't belong here!!"
    rm LSDTopoTools
  else
    echo "Let me just carry on here. Don't worry about what I'm doing."
fi


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
echo "I am here: $DATA_DIR"
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




