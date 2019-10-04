# update-calibre-dedrm-plugin
A shell script to update the calibre DeDRM plugin for MacOS but not before modifying Alf's DeDRM plugin to enable ripping of DRM from Library/Rented Books.  It was tedious to do this everytime there was a new update the the plugin, so I wrote this short shell script. 

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
