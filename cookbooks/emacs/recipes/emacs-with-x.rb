#
# Cookbook Name:: emacs
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Run somehting like this:
#   sudo chef-client --local-mode --runlist 'recipe[emacs::emacs-with-x]'

# Set up a tmp srcdir
srcdir = "#{Chef::Config[:file_cache_path]}/emacs-source"

# Update the system

case node['platform']
#====================================================================
# Debian, Ubuntu
#====================================================================
when 'debian', 'ubuntu'

  bash "build-dep emacs24" do
    code <<-EOC
    sudo apt-get -y build-dep emacs24
    EOC
  end


  %w{ git-core build-essential texinfo autoconf libncurses-dev gnutls-bin}.each {|prereq| package prereq}

  # Install "build essentials"
  
  package "build-essential"

  # Install dependancies
  #
  # TODO sudo apt-get -y build-dep emacs23

  %w(unzip 
     postfix 
     git 
     ispell
     aspell
     aspell-en
     ).each do |pkg|
    package pkg
  end

#====================================================================
# CentOS
#====================================================================
when 'centos'

  # CentOS equivialnt ?
  
  #bash "build-dep emacs" do
  #   code <<-EOC
  #  sudo apt-get -y build-dep emacs
  #  EOC
  #end
  

  # Install "build essentials"
  
  bash "yum groupinstall Development tools" do
    user "root"
    group "root"
    code <<-EOC
      yum groupinstall "Development tools" -y
    EOC
    not_if "yum grouplist installed | grep 'Development tools'"
  end

  bash "yum groupinstall Development Libraries" do
    user "root"
    group "root"
    code <<-EOC
      yum groupinstall "Development Libraries" -y
    EOC
    not_if "yum grouplist installed | grep 'Development Libraries'"
  end

  # Install dependancies
  #
  # TODO centos equivilant of ?sudo apt-get -y build-dep emacs23?

  # Install packages needed
  %w(
    git
    man
    postfix
    ispell
    aspell
    aspell-en
    gnutls
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

  # CentOS equivialnt ?
  
  #bash "build-dep emacs" do
  #   code <<-EOC
  #  sudo apt-get -y build-dep emacs
  #  EOC
  #end
  

  # Install "build essentials"
  
  bash "yum groupinstall Development tools" do
    user "root"
    group "root"
    code <<-EOC
      yum groupinstall "Development tools" -y
    EOC
    not_if "yum grouplist installed | grep 'Development tools'"
  end

  bash "yum groupinstall Development Libraries" do
    user "root"
    group "root"
    code <<-EOC
      yum groupinstall "Development Libraries" -y
    EOC
    not_if "yum grouplist installed | grep 'Development Libraries'"
  end

  # Install packages needed

  %w(
    git
    man
    postfix
    ispell
    aspell
    aspell-en
    gnutls
  ).each do |pkg|
    package pkg do
      options "--enablerepo=epel"
      action :install
    end
  end
end

# Install dependancies
#

# Pull latest emacs sources using git

git "#{Chef::Config[:file_cache_path]}/emacs-source" do  
  repository "https://github.com/mirrors/emacs.git"
  action :checkout  
end  

# Compile Emacs

bash "build emacs" do
  cwd srcdir
  creates "#{srcdir}/src/emacs"
  code <<-EOH
    ./autogen.sh && \
    ./configure && \
    make bootstrap && \
    make 2>&1 >| make-#{node.name}-#{node['ohai_time']}
  EOH
end  
  
execute "install emacs" do
  cwd srcdir
  command "make install 2>&1 >| make-#{node.name}-#{node['ohai_time']}"
  creates "/usr/local/bin/emacs"
  only_if "#{srcdir}/src/emacs --version"
end

# Cleanup 

