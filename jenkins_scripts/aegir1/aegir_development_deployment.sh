#!/bin/bash
#
# Wrapper script for our fabfile, to be called from Jenkins
#

# Where our fabfile is
FABFILE=/var/jenkins_scripts/development_fabfile.py

HOST=$1
SITE=$2
PROFILE=$3
WEBSERVER=$4
DBSERVER=$5
BUILD_NUMBER=$6
GIT_URL=$7
DIFF_ID=$8
BASE_GIT_COMMIT=$9
BRANCH=$10
DATE=`date +%Y%m%d%H%M%S`

if [[ -z $HOST ]] || [[ -z $SITE ]] || [[ -z $PROFILE ]] || [[ -z $WEBSERVER ]] || [[ -z $DBSERVER ]] || [[ -z $BUILD_NUMBER ]] || [[ -z $GIT_URL ]] || [[ -z $DIFF_ID ]] || [[ -z $BASE_GIT_COMMIT ]] || [[ -z $BRANCH ]]
then
  echo "Missing args! Exiting"
  exit 1
fi


# Array of tasks - these are actually functions in the fabfile, as an array here for the sake of abstraction
if [ $BUILD_NUMBER -eq "1" ]; then
  # This is a first-time ever build. Let's install a site instead of migrate it
  TASKS=(
   build_platform
   clone_site
   save_alias
   import_site
  )
else
  TASKS=(
    build_platform
    save_alias
    clone_site
    import_site
  )
fi

# Loop over each 'task' and call it as a function via the fabfile, 
# with some extra arguments which are sent to this shell script by Jenkins
for task in ${TASKS[@]}; do
  fab -f $FABFILE -H $HOST:7822 $task:site=$SITE,profile=$PROFILE,webserver=$WEBSERVER,dbserver=$DBSERVER,build=$DATE,git_url=$GIT_URL,diff_id=$DIFF_ID,base_git_commit=$BASE_GIT_COMMIT,branch=$BRANCH || exit 1
done
