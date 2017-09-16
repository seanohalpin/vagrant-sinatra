# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'tmpdir'
require_relative 'config-helper'

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
#

proxy = ENV["https_proxy"]
proxy_env = if proxy
              {
                "HTTPS_PROXY" => proxy,
                "HTTP_PROXY"  => proxy,
                "https_proxy" => proxy,
                "http_proxy"  => proxy,
              }
            else
              {}
            end

mysql_env = {
  "MYSQL_ROOT_PASSWORD" => "root123",
  "MYSQL_APP_HOST"      => "localhost",
  "MYSQL_APP_DB"        => "sinatra_app_db",
  "MYSQL_APP_USERNAME"  => "sinatra_app_user",
  "MYSQL_APP_PASSWORD"  => "app123",
}

RBENV_RUBY_VERSION = "2.4.2"

env = proxy_env.merge(mysql_env)

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  h = ConfigHelper.new(config, env)

  # Forward port
  config.vm.network :forwarded_port, guest: 5000, host: 8000, host_ip: "127.0.0.1"

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/trusty64"
  # Set proxy for login environment
  h.truncate "/etc/profile.d/env-proxy.sh", run: "always"
  proxy_env.each do |key, value|
    h.append "/etc/profile.d/env-proxy.sh", "export #{key}=#{value}", run: "always"
  end

#  h.new_file "/etc/profile.d/env-proxy2.sh", run: "always" do |file|
#    proxy_env.each do |key, value|
#      file.append "export XXX_#{key}=#{value}", run: "always"
#    end
#  end

  # Set up application mysql vars
  h.truncate "/etc/profile.d/env-mysql.sh", run: "always"
  mysql_env.each do |key, value|
    h.append "/etc/profile.d/env-mysql.sh", "export #{key}=#{value}", run: "always"
  end
  h.step "update-sudoers"
  h.step "bootstrap"
  # Expects =MYSQL_*= vars in =env=
  h.step "install-mysql"
  # rbenv
  # Run this as a separate step so when the next command is run, =$USER= will be a member of the group
  h.inline "sudo usermod -a -G staff $USER", name: "add-to-group"
  h.step "install-rbenv"
  h.copy_file source: "provision/fs/etc/profile.d/rbenv-init.sh", destination: "/etc/profile.d/"

  h.inline "rbenv install #{RBENV_RUBY_VERSION}", name: "rbenv install"
  h.inline "rbenv global #{RBENV_RUBY_VERSION}", name: "rbenv global"
  h.inline "gem install bundle --no-ri --no-rdoc", name: "install bundle"

  # Install gems (as user, not root)
  h.inline "cd /vagrant && bundle", run: :always, privileged: false, name: "run bundle"

  # Install god service
  h.inline "cp /vagrant/provision/fs/etc/systemd/system/god.service /etc/systemd/system/god.service", name: "install service"

  # Run app (via god)
  h.step "start-daemon"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
