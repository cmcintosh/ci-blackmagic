#!/bin/bash

# Prepare to run tests
cd $PROJECT_ROOT
echo Run QA tests against branch. $PANTHEON_MULTIDEV
export BEHAT_PARAMS='{"extensions" : {"Behat\\MinkExtension" : {"base_url" : "https://my.dev.site/"}}}'
cd $PROJECT_ROOT/$TESTS_PATH/behat
echo Updating Behat dependencies
# rm -rf vendor
# composer update
echo Starting behat tests
./bin/behat --format=pretty > $PROJECT_ROOT/results.txt
