#!/bin/bash
#
# Wrapper script for our fabfile, to be called from Jenkins
#

# Where our fabfile is
FABFILE=/var/jenkins_scripts/production_fabfile.py

AEGIR_URL=$1
PRODUCTION_URL=$2
INSTALL_PROFILE=$3
WEB_SERVER=$4
DB_SERVER=$5
GIT_URL=$6
GIT_BRANCH=$7
BUILD_NUMBER=$8
PORT=$9
CLIENT_NAME=$10
CLIENT_EMAIL=$11
DATE=`date +%Y%m%d%H%M%S`

if [[ -z $AEGIR_URL ]] || [[ -z $PRODUCTION_URL ]] || [[ -z $INSTALL_PROFILE ]] || [[ -z $WEB_SERVER ]] || [[ -z $DB_SERVER ]] || [[ -z $GIT_URL ]] || [[ -z $GIT_BRANCH ]] || [[ -z $BUILD_NUMBER ]] || [[ -z $PORT ]] || [[ -z $CLIENT_NAME ]] || [[ -z $CLIENT_EMAIL ]]
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
   install_site
  )
else
  TASKS=(
    build_platform
    migrate_site
    save_alias
    import_site
  )
fi

# Loop over each 'task' and call it as a function via the fabfile, 
# with some extra arguments which are sent to this shell script by Jenkins
for task in ${TASKS[@]}; do
  fab -f $FABFILE -H $AEGIR_URL:$PORT $task:site=$PRODUCTION_URL,profile=$INSTALL_PROFILE,webserver=$WEB_SERVER,dbserver=$DB_SERVER,git_url=$GIT_URL,branch=$GIT_BRANCH,build=$BUILD_NUMBER,client_name=$CLIENT_NAME,client_email=$CLIENT_EMAIL || exit 1
done
