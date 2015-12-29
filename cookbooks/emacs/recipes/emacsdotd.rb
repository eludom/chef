# Cookbook Name:: emacs
# Recipe:: emacsdotd
# Purpose:: Pull my .emacs.d files from git and insall
#
# Copyright (c) 2015 George Jones, All Rights Reserved.

# Run somehting like this:
#   chef-client --local-mode --runlist 'recipe[emacs::emacsdotd]'


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

targetdir="#{ENV['HOME']}/git/github.com/eludom/.emacs.d"

directory targetdir do
  recursive true
end

# Pull latest org-mode sources using git

git targetdir do
  repository "git@github.com:eludom/.emacs.d.git"
  action :checkout  
end  

# install

bash "Install .emacs.d files" do
  cwd targetdir
  code <<-EOH
    ./makelinks 
  EOH
end  
