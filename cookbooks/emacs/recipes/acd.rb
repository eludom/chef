# Cookbook Name:: Emacs
# Recipe:: Recipe to install acd_cli
#
# Copyright (c) 2015 George Jones, All Rights Reserved.

# Run somehting like this:
#   sudo chef-client --local-mode --runlist 'recipe[emacs::acd]'


# Update the system

case node['platform']
#====================================================================
# Debian, Ubuntu
#====================================================================
when 'debian', 'ubuntu'

  # Install dependancies
  #

  %w(python3 
     python3-pip
     fuse
     fuse-libs   
     fuse-devel
    ).each do |pkg|
    package pkg
  end

#====================================================================
# CentOS
#====================================================================
when 'centos'


  # Install dependancies
  #

  %w(
    python34
    python34-pip
    fuse
    fuse-libs
    fuse-devel
  ).each do |pkg|
    package pkg do
      options "--enablerepo=epel"
      action :install
    end
  end

#====================================================================
# AmazonLinux
#====================================================================
when 'amazon'


  # Install git

  %w(
    python34
    python34-pip
    fuse
    fuse-libs
    fuse-devel
  ).each do |pkg|
    package pkg do
      options "--enablerepo=epel"
      action :install
    end
  end
end

#  Steps done by hand to install.  Should be automated.
#  See https://github.com/yadayada/acd_cli/blob/master/docs/setup.rst
#
#  - edit this .rb file
#
#  - run this .rb file
#
#    sudo chef-client --local-mode --runlist 'recipe[emacs::acd]'
#
#  - Set up python virtual env
#
#      mkdir ~/virtenv
#      cd ~/virtenv
#      virtualenv acdcli
#      source acdcli/bin/activate
#
#  - sudo install ... should I have to use sudo if I'm using a virutalenv
#
#      sudo pip3 install --upgrade git+https://github.com/yadayada/acd_cli.git
#
#  - oauth authentication
#    
#      Do oath authentication when prompted, and copy resulting file to:     
#      ~/.cache/acd_cli/oauth_data
#
#  - Create mountpoint
#
#      sudo mkdir /acd
#      sudo chown ec2_user /acd
#
#  - Mount acd
#
#      acd_cli mount /acd
#
#

# Cleanup 

