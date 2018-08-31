#!/bin/sh
## Clone into DataTables and its various supporting repos

# SSH key setup
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
ssh -T git@github.com

ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts
ssh -T git@bitbucket.org

# DataTablesSrc
git clone git@github.com:DataTables/DataTablesSrc.git

# Editor and packages
# Note that if you don't have access to the bitbucket Editor repos, you'll get
# an access error here, but it won't halt the build.
mkdir -p DataTablesSrc/extensions
cd DataTablesSrc/extensions
git clone git@bitbucket.org:sprymedia/Editor.git
git clone git@bitbucket.org:sprymedia/Editor-Node-Demo.git
git clone git@bitbucket.org:sprymedia/Editor-PHP-Demo.git
git clone git@bitbucket.org:sprymedia/Editor-NETCore-Demo.git
git clone git@bitbucket.org:sprymedia/Editor-NETFramework-Demo.git
git clone git@github.com:DataTables/Editor-Node.git
git clone git@github.com:DataTables/Editor-PHP.git
git clone git@github.com:DataTables/Editor-NET.git

cd Editor-Node
npm install

cd ../Editor-Node-Demo
npm install

# DataTables site
# Needed for email notifications (SpryMedia devs)
cd ../../../
git clone git@bitbucket.org:sprymedia/datatables-site.git
sudo cp datatables-site/test/tools/ssmtp.conf /etc/ssmtp/ssmtp.conf
sudo cp datatables-site/test/tools/revaliases /etc/ssmtp/revaliases

# Build - will also checkout and build the extensions
cd DataTablesSrc/build
./make.sh all debug

# ugly way of common code in case editor doesn't get checked out
# vagrant doesn't seem to support conditionals, will check at some point in the future
mkdir -p /home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/php
cp /vagrant/config.php /home/vagrant/DataTablesSrc/built/DataTables/extensions/Editor/php
