#!/bin/bash

# chef-solo install for Ubuntu on Slicehost

# cat ~/.ssh/id_rsa.pub | ssh root@YOUR_SLICE_IP_ADDRESS "mkdir -m 0700 -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 0600 ~/.ssh/authorized_keys"
# ssh root@YOUR_SLICE_IP_ADDRESS "bash < <( curl -L https://github.com/tripleonard/chef-solo-bootstrap/raw/master/chef-solo-bootstrap.sh )"

ruby_gems_version=1.3.7

# update system

sudo aptitude --quiet --assume-yes update
sudo aptitude -y install build-essential build-dep git-core ruby ruby-dev libopenssl-ruby irb wget ssl-cert


# install rubygems

cd /tmp
wget http://production.cf.rubygems.org/rubygems/rubygems-$ruby_gems_version.tgz
tar zxf rubygems-$ruby_gems_version.tgz
cd rubygems-$ruby_gems_version
sudo ruby setup.rb --no-format-executable

#install chef

sudo gem install chef --no-ri --no-rdoc

# Add solo.rb for chef-solo
echo 'file_cache_path "/tmp/chef-solo"
cookbook_path "/tmp/chef-solo/cookbooks"
# json_attribs "http://www.example.com/node.json"
# recipe_url "http://www.example.com/chef-solo.tar.gz"' | sudo tee /etc/chef/solo.rb

