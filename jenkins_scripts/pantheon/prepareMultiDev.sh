#!/bin/bash
echo Logging into Pantheon
$TERMINUS_PATH auth login --machine-token=zSSjF1BsIQ7kRLQyUCQzexfcezqkUQaHWX3N8JiiSwopv
echo Creating Pantheon Multidev Environment
$TERMINUS_PATH site create-env --site=meetingpackagecom --to-env=$PANTHEON_BRANCH --from-env=live
