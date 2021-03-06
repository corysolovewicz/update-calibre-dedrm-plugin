# update-calibre-dedrm-plugin
A shell script to download, edit the calibre DeDRM plugin for MacOS to allow ripping of DRM from Library/Rented Books, and then import the newly edited plugin into calibre.  It was tedious to do this everytime there was a new update to the plugin, so I wrote this short shell script to automate the process instead. 

# Dependencies
* [Calibre for MacOS](https://calibre-ebook.com/download_osx)

# Instructions
`git clone https://github.com/corysolovewicz/update-calibre-dedrm-plugin`

`cd update-calibre-dedrm-plugin`

`chmod 755 update_calibre_dedrm_plugin.sh`

`./update_calibre_dedrm_plugin.sh`

or

`./update_calibre_dedrm_plugin.sh 6.6.3`


# References
This script is based on the [this guide](https://www.reddit.com/r/Piracy/comments/3ma9qe/guide_how_to_rent_your_textbooks_for_free_from/)

[Apprentice Alf's Blog](https://apprenticealf.wordpress.com/)

[DeDRM Tools Github Repo](https://github.com/apprenticeharper/DeDRM_tools)

You can also keep Calibre updated by using [this tool](https://github.com/fny/calibre-Installer)
