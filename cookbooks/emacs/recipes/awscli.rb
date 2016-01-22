# Cookbook Name:: emacs
# Recipe:: awscli
# Purpose:: install awscli
#
# Copyright (c) 2015 George Jones, All Rights Reserved.

# Run somehting like this:
#   sudo chef-client --local-mode --runlist 'recipe[emacs::awscli]'


# Update the system

case node['platform']
#====================================================================
# Debian, Ubuntu
#====================================================================
when 'debian', 'ubuntu'


  # Install dependancies
  #
  # TODO sudo apt-get -y build-dep emacs23

  %w(python-pip
     ).each do |pkg|
    package pkg
  end

#====================================================================
# CentOS
#====================================================================
when 'centos'

  # Install dependancies

  %w(python-pip
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

  # Install packages needed

  %w(python-pip
  ).each do |pkg|
    package pkg do
      options "--enablerepo=epel"
      action :install
    end
  end
end

# Common actions
#

#file "#{ENV['HOME']}/somefile" do
#  action :create_if_missing
#end

#checkoutdir="#{ENV['HOME']}/git/github.com/eludom/dotfiles"
#
#directory checkoutdir do
#  recursive true
#end
#
## Pull latest sources using git
#
#git checkoutdir do  
#  repository "git@github.com:eludom/dotfiles.git" 
#  action :checkout  
#end  
#
## Install
#
bash "install amazon cli" do
  code <<-EOH
    pip install awscli 
  EOH
end  
