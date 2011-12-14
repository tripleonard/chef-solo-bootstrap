#!/bin/bash

# chef-solo install for Ubuntu on Slicehost

# cat ~/.ssh/id_rsa.pub | ssh root@YOUR_SLICE_IP_ADDRESS "mkdir -m 0700 -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 0600 ~/.ssh/authorized_keys"
# ssh -t root@YOUR_SLICE_IP_ADDRESS "bash < <( curl -L -k https://github.com/tripleonard/chef-solo-bootstrap/raw/master/chef-solo-bootstrap.sh )"

# ssh -t solves tty and curl -k switch removes ssl check
before="$(date +%s)"

ruby_gems_version=1.7.2
chef_version=0.10.4

# update system
sudo aptitude --quiet --assume-yes update
sudo aptitude -y install build-essential build-dep git-core ruby ruby-dev libopenssl-ruby irb wget ssl-cert


# install rubygems
cd /tmp
wget http://production.cf.rubygems.org/rubygems/rubygems-$ruby_gems_version.tgz
tar zxf rubygems-$ruby_gems_version.tgz
cd rubygems-$ruby_gems_version
sudo ruby setup.rb --no-format-executable

#install chef and ohai
sudo gem install chef -v=$chef_version --no-ri --no-rdoc
sudo gem install ohai --no-ri --no-rdoc

# Add solo.rb for chef-solo
sudo mkdir /etc/chef
echo 'file_cache_path "/tmp/chef-solo"
cookbook_path ["/tmp/chef-solo/cookbooks", "/tmp/chef-solo/site-cookbooks"]
role_path "/tmp/chef-solo/roles"
# json_attribs "http://www.example.com/node.json"
# recipe_url "http://www.example.com/chef-solo.tar.gz"' | sudo tee /etc/chef/solo.rb

after="$(date +%s)"
elapsed_seconds="$(expr $after - $before)"
echo Elapsed time for code block: $elapsed_seconds
