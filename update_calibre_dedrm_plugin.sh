#!/bin/bash 

# come up with way to grab the latest version number from
# https://github.com/apprenticeharper/DeDRM_tools/releases/latest
VERSION="6.6.3"

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
    printf "\n############################# Using default version ${VERSION} #############################"
    printf "\n"
fi


# Download Alf's DeDRM tools
printf "\n############################# Downloading AlfDeDRM Tools......... #############################"
printf "\n"
URL=https://github.com/apprenticeharper/DeDRM_tools/releases/download/v$VERSION/DeDRM_tools_$VERSION.zip
# echo $URL
# wget_output will be 0 if $URL is found, otherwise it is not found so we should exit

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
cd DeDRM_tools_$VERSION/DeDRM_calibre_plugin/

# unzip DeDRM_plugin.zip archive
printf "\n############################# Unzipping Alf's DeDRM Calibre Plugin #############################"
printf "\n"
# Check if archive exists before attempting to unzip
if [ -e DeDRM_plugin.zip ]
then
	echo "DeDRM_plugin.zip exists prepare to unzip"
	if [ ! -e DeDRM_plugin ]
	then
		unzip DeDRM_plugin.zip -d DeDRM_plugin 
	else
		echo "The directory DeDRM_plugin already exists, no need to unzip archive"
	fi
else
	echo "ERROR: Something is wrong with DeDRM_tools_$VERSION. There is no DeDRM_plugin.zip. Exiting...."
	exit;
fi


# enter unzip calibre plugin
cd DeDRM_plugin

# edit mobiderm.py to remove the library/rented book restriction
printf "\n############################# Editing the mobiderm.py file to remove the library/rented ebooks restriction #############################"
printf "\n"
if [ -e mobidedrm.py ]
then
	echo "mobidedrm.py exists preparing to edit"
	sed -i -e 's/if val406 != 0:/#if val406 != 0:/g' mobidedrm.py
	sed -i -e 's/raise DrmException(u"Cannot decode library or rented ebooks.")/#raise DrmException(u"Cannot decode library or rented ebooks.")/g' mobidedrm.py
else
	echo "ERROR: Something is wrong with DeDRM_tools_$VERSION. There is no mobidedrm.py. Exiting...."
	exit;
fi 

# zip newly modified calbre plugin
printf "\n############################# Zipping newly modified calbre plugin #############################"
printf "\n"
zip -r DeDRM_plugin_$VERSION.zip *
if [ ! -e DeDRM_plugin_$VERSION.zip ]
then
	echo "ERROR: DeDRM_plugin_$VERSION.zip doesn't exist. Something went wrong when creating it. Exiting...."
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
calibre-customize --add-plugin=DeDRM_plugin_$VERSION.zip
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
echo "Install complete! Launching calibre!"
osascript -e 'tell application "calibre" to activate' || error_exit "Calibre failed to open!"

printf "\n"
printf "\nYou can verify that the DeDRM plugin was installed in calibre"
printf "\nCalibre -> Preferences... -> Plugins -> File type plugins"
printf "\nWhere you should see DeDRM($VERSION)"
printf "\n"
printf "\n"
