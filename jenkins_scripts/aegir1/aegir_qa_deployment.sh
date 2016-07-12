#!/bin/bash
#
# Wrapper script for our fabfile, to be called from Jenkins
#

# Where our fabfile is
FABFILE=/var/jenkins_scripts/qa_fabfile.py

AEGIR_URL=$1
PRODUCTION_SITE=$2
INSTALL_PROFILE=$3
WEB_SERVER=$4
DB_SERVER=$5
BUILD_NUMBER=$6
GIT_URL=$7
GIT_BRANCH=$8
SSH_PORT=$9
DATE=`date +%Y%m%d%H%M%S`

if [[ -z $AEGIR_URL ]] || [[ -z $PRODUCTION_SITE ]] || [[ -z $INSTALL_PROFILE ]] || [[ -z $WEB_SERVER ]] || [[ -z $DB_SERVER ]] || [[ -z $BUILD_NUMBER ]] || [[ -z $GIT_URL ]] || [[ -z $GIT_BRANCH ]] || [[ -z $SSH_PORT ]]
then
  echo "Missing args! Exiting"
  exit 1
fi


# Array of tasks - these are actually functions in the fabfile, as an array here for the sake of abstraction
if [ $BUILD_NUMBER -eq "1" ]; then
  # This is a first-time ever build. Let's install a site instead of migrate it
  TASKS=(
   build_platform
   save_alias
   clone_site
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
  fab -f $FABFILE -H $AEGIR_URL:$SSH_PORT $task:site=$PRODUCTION_SITE,profile=$INSTALL_PROFILE,webserver=$WEB_SERVER,dbserver=$DB_SERVER,build=$DATE,git_url=$GIT_URL,branch=$GIT_BRANCH || exit 1
done
