drush provision-save @platform_demociqa --context_type=platform \
    --root=${WORKSPACE} \
    --web_server=@server_webexamplecom
drush provision-verify @platform_demociqa
