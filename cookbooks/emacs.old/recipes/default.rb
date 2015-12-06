#
# Cookbook Name:: emacs
# Recipe:: default
#
# Install latest emacs from src, per
#
#   http://ergoemacs.org/emacs/building_emacs_from_git_repository.html
#
# as chef cookbook.
#
# George Jones <gmj AT pobox DOT com>
#
#
#
package 'build-essential'
package 'git'

## Apt-get update if it has not been done in 24 hours
#execute "apt-get-update-periodic" do
#  command "apt-get update"
#  ignore_failure true
#  only_if do
#    File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
#    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
#  end
#end

# Install postfix first to prevent it from prompting during 'apt-get -y build-dep emacs23'
bash "install_postfix" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  debconf-set-selections <<< "postfix postfix/mailname string `hostname`"
  debconf-set-selections <<< "postfix postfix/main_mailer_type string 'No configuration'"
  apt-get install -y postfix
  EOH
end

bash "install_emacs" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    sudo apt-get -y build-dep emacs23 
    mkdir -p ~/git
    cd ~/git

    if [ -d ~/git/emacs ]; then
      cd ~/git/emacs
      git pull
    else
      git clone https://github.com/mirrors/emacs 
      cd ~/git/emacs
    fi
    
   ./autogen.sh
   ./configure
    make bootstrap
    sudo make install
  EOH

end



