from fabric.api import *
import time

env.user = 'aegir'
env.shell = '/bin/bash -c'

# Download and import a platform using Drush Make
def build_platform(site, profile, webserver, dbserver, git_url, branch, build, client_name, client_email):
  print "===> Building the platform..."
 
  print "===> Getting Git repo " 
  run("git clone %s /var/aegir/platforms/%s/%s-%s" % (git_url, webserver, site, build) )
  run("git --work-tree=/var/aegir/platforms/%s/%s-%s  --git-dir /var/aegir/platforms/%s/%s-%s/.git reset --hard" % (webserver, site, build, webserver, site, build) )
  run("git --work-tree=/var/aegir/platforms/%s/%s-%s --git-dir /var/aegir/platforms/%s/%s-%s/.git checkout remotes/origin/%s" % (webserver, site, build, webserver, site, build, branch) )
  print "==> Provision save for aegir"
  run("drush --root='/var/aegir/platforms/%s/%s-%s' provision-save '@platform_%s_%s' --context_type='platform'" % (webserver, site, build, site, build) )
  print "==> Hosting import"
  run("drush @hostmaster hosting-import '@platform_%s_%s'" % (site, build) )
  run("drush @hostmaster hosting-dispatch")
  time.sleep(5)

# Install a site on a platform, and kick off an import of the site
def install_site(site, profile, webserver, dbserver, git_url, branch, build, client_name, client_email):
  print "===> Installing the site for the first time..."
  run("drush @%s provision-install --client_email=%s" % (site, client_email) )
  run("drush @hostmaster hosting-task @platform_%s_%s verify --force" % (site, build) )
  run("drush @hostmaster hosting-dispatch")
  run("drush @hostmaster hosting-task @%s verify --force" % site)
  time.sleep(5)

# Migrate a site to a new platform
def migrate_site(site, profile, webserver, dbserver, git_url, branch, build, client_name, client_email):
  print "===> Migrating the site to the new platform"
  run("drush @%s provision-migrate '@platform_%s_%s'" % (site, site, build))
  time.sleep(5)

# Save the Drush alias to reflect the new platform
def save_alias(site, profile, webserver, dbserver, git_url, branch, build, client_name, client_email):
  print "===> Updating the Drush alias for this site"
  run("drush provision-save @%s --context_type=site --uri=%s --platform=@platform_%s_%s --server=@server_%s --db_server=@server_%s --profile=%s --client_name=%s --force" % (site, site, site, build, webserver, dbserver, profile, client_name))
  time.sleep(5)

# Import a site into the frontend, so that Aegir learns the site is now on the new platform
def import_site(site, profile, webserver, dbserver, git_url, branch, build, client_name, client_email):
  print "===> Refreshing the frontend to reflect the site under the new platform"
  run("drush @hostmaster hosting-import @%s" % site)
  run("drush @hostmaster hosting-task @platform_%s_%s verify --force" % (site, build) )
  run("drush @hostmaster hosting-import @%s" % site)
  run("drush @hostmaster hosting-task @%s verify --force" % site)

