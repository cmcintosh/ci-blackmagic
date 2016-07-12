#!/bin/bash
echo Checking out branch remotes/origin/$FEATURE
git checkout $FEATURE

echo Compiling CSS
cd $THEME_PATH
compass clean && compass compile
git add .
git commit -m "Building css for pantheon."
git push pantheon $FEATURE:$PANTHEON_BRANCH
