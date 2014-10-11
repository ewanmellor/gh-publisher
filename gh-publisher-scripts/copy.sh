#
# Use this file to configure whichever artifacts you wish to publish.
#
# You have the following variables available:
#
# GH_PUBLISHER_PROJECT_DIR - The root of your project repository.
# GH_PUBLISHER_PUBLISH_DIR - The destination for files to be published.
# GH_PUBLISHER_SCRIPTS_DIR - The gh-publisher-scripts directory.
#
# The current working directory is $GH_PUBLISHER_PROJECT_DIR.
#

find . \( \
     -name \*.html -o \
     -name \*.css -o \
     -name \*.js -o \
     -name \*.gif -o \
     -name \*.jpeg -o \
     -name \*.jpg -o \
     -name \*.png -o \
     -name \*.pdf \
     \) -print0 |
    rsync -av --files-from=- --from0 ./ "$GH_PUBLISHER_PUBLISH_DIR"
