#!/bin/bash
if [${BUILD_NUMBER} > 1]; then
  LAST_BUILD_NUMBER=$(expr ${BUILD_NUMBER} - 1)
  # Step 1. Move old develop site to new platform.
  sudo su -c "drush @${DEV_NAME}.wembassy.com provision-migrate @platform_${PROJECT}_${BRANCH}_${BUILD_NUMBER}" -s /bin/sh aegir
  sudo su -c "drush @${DEV_NAME}.wembassy.com provision-verify" -s /bin/sh aegir
  # Step 2. remove old platform
  sudo su -c "drush @platform_${PROJECT}_${BRANCH}_${LAST_BUILD_NUMBER} provision-delete" -s /bin/sh aegir
fi
