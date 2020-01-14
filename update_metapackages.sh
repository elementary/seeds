#!/bin/bash
set -e

#------------------------------------------------------------------#
# Run updates to elementary metapackages whenever changes are made #
# https://github.com/elementary/metapackages                       #
#------------------------------------------------------------------#

# Check for variables and args
if [ -z "$1" ]; then
  echo "\033[0;31mERROR: No branch specified.\033[0m"  && exit 1
else
  BRANCH="$1"
fi

# install dependencies
apt-get update
apt-get install -y git devscripts debootstrap germinate

echo "Updating metapackages..."
git checkout "$BRANCH"
sh update
git add .
git commit -m "Automatic update via elementary seeds"
git push origin "$BRANCH"
echo "Push complete"
