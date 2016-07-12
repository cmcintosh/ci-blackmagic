echo Logging into pantheon
$TERMINUS_PATH auth login --machine-token=zSSjF1BsIQ7kRLQyUCQzexfcezqkUQaHWX3N8JiiSwopv
echo Removing environment.
terminus site delete-env --site=$PANTHEON_SITE --env=$PANTHEON_BRANCH
