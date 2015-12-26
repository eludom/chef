# Cookbook Name:: emacs
# Recipe:: dotfiles
# Purpose:: pull and install my dotfiles
#
# Copyright (c) 2015 George Jones, All Rights Reserved.

# Run somehting like this:
#   sudo chef-client --local-mode --runlist 'recipe[emacs::dotfiles]'


# Update the system

case node['platform']
#====================================================================
# Debian, Ubuntu
#====================================================================
when 'debian', 'ubuntu'


  # Install dependancies
  #
  # TODO sudo apt-get -y build-dep emacs23

  %w(
     ).each do |pkg|
    package pkg
  end

#====================================================================
# CentOS
#====================================================================
when 'centos'

  # Install dependancies

  %w(
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

  %w(
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

checkoutdir="#{ENV['HOME']}/git/github.com/eludom/dotfiles"

directory checkoutdir do
  recursive true
end

# Pull latest sources using git

git checkoutdir do  
  repository "git@github.com:eludom/dotfiles.git" 
  action :checkout  
end  

# Install

bash "build latest orgmode" do
  cwd checkoutdir
  #creates "#{checkoutdir}/lisp/org-version.el"
  code <<-EOH
    ./makelinks
  EOH
end  
