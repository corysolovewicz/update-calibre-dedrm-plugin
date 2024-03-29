#!/bin/bash 

# come up with way to grab the latest version number from
# https://github.com/apprenticeharper/DeDRM_tools/releases/latest
#VERSION="6.6.3"
printf "\n############################# Getting the Latest Version Tag from GitHub #############################"
printf "\n"
VERSION=`curl https://github.com/apprenticeharper/DeDRM_tools/releases/latest | sed 's|.*tag/v\(.*\)">redirect.*|\1|'`
printf "\n############################# The Latest Version Tag is $VERSION #############################"
printf "\n"

# Check if Operating System is MacOS
[ `uname` != 'Darwin' ] && error_exit "This installation script is incompatible with `uname` operating systems."

# Check if calibre is open and if so, tell it to quit
if [ `osascript -e 'tell application "System Events" to (name of processes) contains "calibre"'` = true ]; then
  echo "Quitting calibre..."
  osascript -e 'tell app "calibre" to quit' || error_exit 'Calibre failed to quit!'
fi

# Check if there's an argument
if [ "$1" != "" ]; then
    VERSION=$1
    printf "\n############################# User passed version is ${VERSION} #############################"
    printf "\n"
else
    printf "\n############################# Using latest version ${VERSION} #############################"
    printf "\n"
fi

# Download Alf's DeDRM tools
printf "\n############################# Downloading AlfDeDRM Tools......... #############################"
printf "\n"
URL=https://github.com/apprenticeharper/DeDRM_tools/releases/download/v$VERSION/DeDRM_tools_$VERSION.zip
# echo $URL
# wget_output will be 0 if $URL is found, otherwise it is not found so we should exit

# Check if the DeDRM_tools_$VERSION.zip doesn't already exist on the file system
if [ ! -e DeDRM_tools_$VERSION.zip ]
then
	wget_output=$(wget -q "$URL")
	# check the value of wget_output (last command run)
	if [ $? -eq 0 ]; 
		then
			echo "That version does exist. Downloading...."
		else
			echo "ERROR: Version $VERSION doesn't exist! Exiting...."
			exit;
	fi
else
	echo "DeDRM_tools_$VERSION.zip already exists, no need to re-download"
fi

# unzip DeDRM Tools
printf "\n############################# Unzipping Alf's DeDRM Tools #############################"
printf "\n"
# Check if archive exists before attempting to unzip
if [ -e DeDRM_tools_$VERSION.zip ]
then
	echo "DeDRM_tools_$VERSION.zip exists prepare to unzip"
	if [ ! -e DeDRM_tools_$VERSION ]
	then
		unzip DeDRM_tools_$VERSION.zip -d DeDRM_tools_$VERSION
	else
		echo "The directory DeDRM_tools_$VERSION already exists, no need to unzip archive"
	fi
else
	echo "ERROR: Something went wrong in downloading DeDRM_tools_$VERSION. Exiting...."
	exit;
fi

# enter into calibre plugin directory
#cd DeDRM_tools_$VERSION/DeDRM_calibre_Plugin/
cd DeDRM_tools_$VERSION/

# unzip DeDRM_Plugin.zip archive
printf "\n############################# Unzipping Alf's DeDRM Calibre Plugin #############################"
printf "\n"
# Check if archive exists before attempting to unzip
if [ -e DeDRM_Plugin.zip ]
then
	echo "DeDRM_Plugin.zip exists prepare to unzip"
	if [ ! -e DeDRM_Plugin ]
	then
		unzip DeDRM_Plugin.zip -d DeDRM_Plugin 
	else
		echo "The directory DeDRM_Plugin already exists, no need to unzip archive"
	fi
else
	echo "ERROR: Something is wrong with DeDRM_tools_$VERSION. There is no DeDRM_Plugin.zip. Exiting...."
	exit;
fi

# enter unzip calibre plugin
cd DeDRM_Plugin

# edit mobiderm.py to remove the library/rented book restriction
printf "\n############################# Editing the mobiderm.py file to remove the library/rented ebooks restriction #############################"
printf "\n"
if [ -e mobidedrm.py ]
then
	echo "mobidedrm.py exists preparing to edit"
	sed -i -e 's/if val406 != 0:/#if val406 != 0:/g' mobidedrm.py
	sed -i -e 's/raise DrmException("Cannot decode library or rented ebooks.")/#raise DrmException("Cannot decode library or rented ebooks.")/g' mobidedrm.py
else
	echo "ERROR: Something is wrong with DeDRM_tools_$VERSION. There is no mobidedrm.py. Exiting...."
	exit;
fi 

if [ -e mobidedrm.py-e ]
then
	echo "mobidedrm.py exists preparing to edit"
	sed -i -e 's/if val406 != 0:/#if val406 != 0:/g' mobidedrm.py-e
	sed -i -e 's/raise DrmException("Cannot decode library or rented ebooks.")/#raise DrmException("Cannot decode library or rented ebooks.")/g' mobidedrm.py-e
else
	echo "ERROR: Something is wrong with DeDRM_tools_$VERSION. There is no mobidedrm.py-e. Exiting...."
	exit;
fi 

# zip newly modified calbre plugin
printf "\n############################# Zipping newly modified calbre plugin #############################"
printf "\n"
zip -r DeDRM_Plugin_$VERSION.zip *
if [ ! -e DeDRM_Plugin_$VERSION.zip ]
then
	echo "ERROR: DeDRM_Plugin_$VERSION.zip doesn't exist. Something went wrong when creating it. Exiting...."
	exit;
fi

# set PATH environment variable if not already set
printf "\n############################# Setting environment path to calibre commandline tools #############################"
printf "\n"
echo "export PATH=/Applications/calibre.app/Contents/MacOS/:\$PATH"
export PATH=/Applications/calibre.app/Contents/MacOS/:$PATH

# load the plugin into calibre
printf "\n############################# Loading the newly modified plugin into calibre #############################"
printf "\n"
calibre-customize --add-plugin=DeDRM_Plugin_$VERSION.zip
#printf "\n"
# this will verify that the plugin is installed
#calibre-customize --list-plugins | grep DeDRM

# ask about cleaning up files

while true; do
    read -p "Do you wish to remove the working files (Y/N) ? " yn
    case $yn in
        [Yy]* ) printf "\n############################# Cleaning up files #############################";cd ../../..;rm -rf DeDRM_tools_${VERSION}*; break;;
        [Nn]* ) cd ../../..;break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# launch calibre
printf "\n"
printf "\n"
echo "############################# Install complete! Launching calibre! #############################"
osascript -e 'tell application "calibre" to activate' || error_exit "Calibre failed to open!"

printf "You can verify that the DeDRM plugin was installed in calibre"
printf "\nCalibre -> Preferences... -> Plugins -> File type plugins"
printf "\nWhere you should see DeDRM($VERSION)"
printf "\n"
printf "\n"
