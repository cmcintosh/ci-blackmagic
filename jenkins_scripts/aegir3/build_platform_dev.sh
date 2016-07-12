#!/bin/bash

# Step 1. Clone the repository, and checkout Development
git clone ${REPOSITORY} ${PLATFORM_PATH}
cd ${PLATFORM_PATH}
git checkout ${BRANCH}
#echo "import pty; pty.spawn('/bin/bash')" > /tmp/asdf.py
#python /tmp/asdf.py

# Step 2. Initialize New Platform with Aegir.
sudo su -c "chown aegir -R ${PLATFORM_PATH}"
sudo su -c "drush provision-save @platform_${PROJECT}_${BRANCH}_${BUILD_NUMBER} \
    --root=${PLATFORM_PATH} \
    --web_server=@server_master --context_type=platform " -s /bin/sh aegir
sudo su -c "drush provision-verify @platform_${PROJECT}_${BRANCH}_${BUILD_NUMBER}" -s /bin/sh aegir
sudo su -c "drush @hostmaster hosting-import @platform_${PROJECT}_${BRANCH}_${BUILD_NUMBER}" -s /bin/sh aegir
