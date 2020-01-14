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

echo "Setting up git credentials..."
# default email and username to github actions user
if [ -z "$GIT_USER_EMAIL" ]; then
  GIT_USER_EMAIL="action@github.com"
fi
if [ -z "$GIT_USER_NAME" ]; then
  GIT_USER_NAME="GitHub Action"
fi
git remote set-url origin https://x-access-token:"$GITHUB_TOKEN"@github.com/elementary/metapackages.git
git config --global user.email "$GIT_USER_EMAIL"
git config --global user.name "$GIT_USER_NAME"
echo "git credentials configured."

echo "Updating metapackages..."
git checkout "$BRANCH"
sh update
git add .
git commit -m "Automatic update via elementary seeds"
git push origin "$BRANCH"
echo "Push complete"
