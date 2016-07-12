from fabric.api import *
import time

env.user = 'aegir'
env.shell = '/bin/bash -c'

# Download and import a platform using Drush Make
def build_platform(site, profile, webserver, dbserver, build, git_url, branch):
  print "===> Building the platform..."
 
  print "===> Getting Git repo " 
  run("git clone %s /var/aegir/platforms/%s/%s" % (git_url, webserver, build) )
  run("git --work-tree=/var/aegir/platforms/%s/%s  --git-dir /var/aegir/platforms/%s/%s/.git reset --hard" % (webserver, build, webserver, build) )
  run("git --work-tree=/var/aegir/platforms/%s/%s --git-dir /var/aegir/platforms/%s/%s/.git checkout %s" % (webserver, build, webserver, build, branch) )
  
  print "==> Provision save for aegir"
  run("drush --root='/var/aegir/platforms/%s/%s' provision-save '@platform_%s' --context_type='platform'" % (webserver, build, build) )
  print "==> Hosting import"
  run("drush @hostmaster hosting-import '@platform_%s'" % build)
  run("drush @hostmaster hosting-dispatch")
  time.sleep(5)

# Install a site on a platform, and kick off an import of the site
def install_site(site, profile, webserver, dbserver, build, git_url, branch):
  print "===> Installing the site for the first time..."
  run("drush @%s%s provision-install --client_email=cmcintosh@wembassy.com" % (build, site) )
  run("drush @hostmaster hosting-task @platform_%s verify --force" % build)
  #time.sleep(5)
  run("drush @hostmaster hosting-dispatch --force")
  #time.sleep(5)
  run("drush @hostmaster hosting-task @%s%s verify --force" % (build, site) )
  time.sleep(5)

# Migrate a site to a new platform
def clone_site(site, profile, webserver, dbserver, build, git_url, branch):
  print "===> Cloning the production site to the new platform"
  run("drush @%s provision-clone '@platform_%s @%s%s '" % (site, build, build, site))

# Save the Drush alias to reflect the new platform
def save_alias(site, profile, webserver, dbserver, build, git_url, branch):
  print "===> Updating the Drush alias for this site"
  run("drush provision-save @%s%s --context_type=site --uri=%s%s --platform=@platform_%s --server=@server_%s --db_server=@server_%s --profile=%s --client_name=admin--force" % (build, site, build, site, build, webserver, dbserver, profile))

# Import a site into the frontend, so that Aegir learns the site is now on the new platform
def import_site(site, profile, webserver, dbserver, build, git_url, branch):
  print "===> Refreshing the frontend to reflect the site under the new platform"
  run("drush @hostmaster hosting-import @%s%s" % (build, site) )
  run("drush @hostmaster hosting-task @platform_%s verify --force" % build)
  run("drush @hostmaster hosting-task @%s%s verify --force" % (build, site) )
  run("drush @hostmaster hosting-task @%s%s enable --force" % (build, site) )
