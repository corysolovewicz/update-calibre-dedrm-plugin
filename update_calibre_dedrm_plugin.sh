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
wget https://github.com/apprenticeharper/DeDRM_tools/releases/download/v$VERSION/DeDRM_tools_$VERSION.zip

# unzip DeDRM Tools
printf "\n############################# Unzipping Alf's DeDRM Tools #############################"
printf "\n"
unzip DeDRM_tools_$VERSION.zip -d DeDRM_tools_$VERSION

# enter into calibre plugin directory
cd DeDRM_tools_$VERSION/DeDRM_calibre_plugin/

# unzip DeDRM_plugin.zip archive
printf "\n############################# Unzipping Alf's DeDRM Calibre Plugin #############################"
printf "\n"
unzip DeDRM_plugin.zip -d DeDRM_plugin 

# enter unzip calibre plugin
cd DeDRM_plugin

# edit mobiderm.py to remove the library/rented book restriction
printf "\n############################# Editing the mobiderm.py file to remove the library/rented ebooks restriction #############################"
printf "\n"
sed -i -e 's/if val406 != 0:/#if val406 != 0:/g' mobidedrm.py
sed -i -e 's/raise DrmException(u"Cannot decode library or rented ebooks.")/#raise DrmException(u"Cannot decode library or rented ebooks.")/g' mobidedrm.py 

# zip newly modified calbre plugin
printf "\n############################# Zipping newly modified calbre plugin #############################"
printf "\n"
zip -r DeDRM_plugin_$VERSION.zip *

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

