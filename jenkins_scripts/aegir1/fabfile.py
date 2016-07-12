from fabric.api import *
import time

env.user = 'aegir'
env.shell = '/bin/bash -c'

# Download and import a platform using Drush Make
def build_platform(site, profile, webserver, dbserver, build, git_url, diff_id, base_git_commit, branch):
  print "===> Building the platform..."
 
  print "===> Getting Git repo " 
  run("git clone %s /var/aegir/platforms/%s/%s" % (git_url, webserver, build) )
  time.sleep(15)
  run("git --work-tree=/var/aegir/platforms/%s/%s  --git-dir /var/aegir/platforms/%s/%s/.git reset --hard" % (webserver, build, webserver, build) )
  #time.sleep(15)
  run("git --work-tree=/var/aegir/platforms/%s/%s --git-dir /var/aegir/platforms/%s/%s/.git checkout dev" % (webserver, build, webserver, build) )
  # run("git --git-dir /var/aegir/platforms/%s/%s/.git reset --hard %s" % (webserver, build, base_git_commit) )
  #time.sleep(15)
  # run("git --git-dir /var/aegir/platforms/%s/%s/.git clean -fdx" % (webserver, build) )

  print "==> applying patch via arc"
  # run("arc patch --nobranch --no-ansi --diff %s --nocommit" % base_git_commit )
  # register everything for this platform with aegir
  print "==> Provision save for aegir"
  # run("sudo su aegir")
  run("drush --root='/var/aegir/platforms/%s/%s' provision-save '@platform_%s' --context_type='platform'" % (webserver, build, build) )
  print "==> Hosting import"
  run("drush @hostmaster hosting-import '@platform_%s'" % build)
  run("drush @hostmaster hosting-dispatch")
  time.sleep(5)

# Install a site on a platform, and kick off an import of the site
def install_site(site, profile, webserver, dbserver, build, git_url, diff_id, base_git_commit, branch):
  print "===> Installing the site for the first time..."
  run("drush @%s provision-install --client_email=cmcintosh@wembassy.com" % (site) )
  run("drush @hostmaster hosting-task @platform_%s verify --force" % build)
  #time.sleep(5)
  run("drush @hostmaster hosting-dispatch --force")
  #time.sleep(5)
  run("drush @hostmaster hosting-task @%s verify --force" % site)
  time.sleep(5)
# Migrate a site to a new platform
def migrate_site(site, profile, webserver, dbserver, build, git_url, diff_id, base_git_commit, branch):
  print "===> Migrating the site to the new platform"
  run("drush @%s provision-migrate '@platform_%s'" % (site, build))

# Save the Drush alias to reflect the new platform
def save_alias(site, profile, webserver, dbserver, build, git_url, diff_id, base_git_commit, branch):
  print "===> Updating the Drush alias for this site"
  run("drush provision-save @%s --context_type=site --uri=%s --platform=@platform_%s --server=@server_%s --db_server=@server_%s --profile=%s --client_name=admin--force" % (site, site, build, webserver, dbserver, profile))

# Import a site into the frontend, so that Aegir learns the site is now on the new platform
def import_site(site, profile, webserver, dbserver, build, git_url, diff_id, base_git_commit, branch):
  print "===> Refreshing the frontend to reflect the site under the new platform"
  run("drush @hostmaster hosting-import @%s" % site)
  run("drush @hostmaster hosting-task @platform_%s verify --force" % build)
  run("drush @hostmaster hosting-import @%s" % site)
  run("drush @hostmaster hosting-task @%s verify --force" % site)
