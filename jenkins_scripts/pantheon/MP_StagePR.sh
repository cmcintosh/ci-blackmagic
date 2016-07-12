#!/bin/bash

# Needed for Repository
REPO_OWNER=cocouz
REPO_NAME=meetingpackage.com
PR_NUMBER=1156                        # Should be passed by CI tool.
REPO_USER=                            # Github.com username
REPO_PASS=                            # Github.com password
FEATURE=features/vendor-dashboard     # Github.com Branch name.
LONG_NAME=vendor-dashboard

# Pantheon Details
PANTHEON_SITE=meetingpackagecom       # Pantheon Site name, should be set as default in script
PANTHEON_BRANCH=${LONG_NAME:0:11}     # Pantheon Branch name- limit to 11 characters
PANTHEON_MULTIDEV=$PANTHEON_BRANCH-$PANTHEON_SITE.pantheonsite.io

# Paths needed
PROJECT_ROOT=/Users/cmcintosh/Documents/Projects/Wembassy/CI/jenkins_scripts/test/meetingpackage.com
THEME_PATH=sites/all/themes/custom/meetingpackage
TERMINUS_PATH=/Users/cmcintosh/Documents/Projects/Wembassy/CI/terminus/bin/terminus
TESTS_PATH=sites/all/tests


echo Checking out branch remotes/origin/$FEATURE
git checkout $FEATURE

echo Compiling CSS
cd $THEME_PATH
compass clean && compass compile
git add .
git commit -m "Building css for pantheon."
git push pantheon $FEATURE:$PANTHEON_BRANCH

echo Logging into Pantheon
$TERMINUS_PATH auth login --machine-token=zSSjF1BsIQ7kRLQyUCQzexfcezqkUQaHWX3N8JiiSwopv
echo Creating Pantheon Multidev Environment
$TERMINUS_PATH site create-env --site=meetingpackagecom --to-env=$PANTHEON_BRANCH --from-env=live

cd $PROJECT_ROOT
echo Run QA tests against branch. $PANTHEON_MULTIDEV
export BEHAT_PARAMS='{"extensions" : {"Behat\\MinkExtension" : {"base_url" : "https://my.dev.site/"}}}'
cd $PROJECT_ROOT/$TESTS_PATH/behat
echo Updating Behat dependencies
# rm -rf vendor
# composer update
echo Starting behat tests
./bin/behat --format=pretty > $PROJECT_ROOT/results.txt
