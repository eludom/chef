# Cookbook Name:: emacs
# Recipe:: org
# Purpose:: Build latest org mode from source
#
# Copyright (c) 2015 George Jones, All Rights Reserved.

# Run somehting like this:
#   sudo chef-client --local-mode --runlist 'recipe[emacs::org]'


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

orgdir="#{ENV['HOME']}/git/orgmode.org/org-mode"

directory orgdir do
  recursive true
end

# Pull latest org-mode sources using git

git orgdir do  
  repository "git://orgmode.org/org-mode.git" 
  action :checkout  
end  

# Make autoloads

bash "build latest orgmode" do
  cwd orgdir
  creates "#{orgdir}/lisp/org-version.el"
  code <<-EOH
    make && \
    make autoloads 2>&1 >| make-#{node.name}-#{node['ohai_time']}
  EOH
end  
