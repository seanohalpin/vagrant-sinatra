# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
#

proxy = ENV["https_proxy"]
proxy_env = if proxy
              {
                "HTTPS_PROXY" => proxy,
                "HTTP_PROXY" => proxy,
                "https_proxy" => proxy,
                "http_proxy" => proxy,
              }
            else
              {}
            end

mysql_env = {
  "MYSQL_ROOT_PASSWORD" => "root123",
  "MYSQL_APP_HOST" => "localhost",
  "MYSQL_APP_DB" => "sinatra_app_db",
  "MYSQL_APP_USERNAME" => "sinatra_app_user",
  "MYSQL_APP_PASSWORD" => "app123",
}

env = proxy_env.merge(mysql_env)

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Forward port
  config.vm.network :forwarded_port, guest: 5000, host: 8000, host_ip: "127.0.0.1"

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/trusty64"
  # Set proxy for login environment
  config.vm.provision :shell, inline: "> /etc/profile.d/set-proxy.sh", run: "always"
  proxy_env.each do |key, value|
    config.vm.provision :shell, inline: "echo \"export #{key}=#{value}\" >> /etc/profile.d/set-proxy.sh", run: "always"
  end
  # Set up application mysql vars
  config.vm.provision :shell, inline: "> /etc/profile.d/mysql-vars.sh"
  mysql_env.each do |key, value|
    config.vm.provision :shell, inline: "echo \"export #{key}=#{value}\" >> /etc/profile.d/mysql-vars.sh"
  end
  config.vm.provision :shell, name: "update-sudoers", path: "vagrant/update-sudoers.sh", env: env
  config.vm.provision :shell, name: "bootstrap", path: "vagrant/bootstrap.sh", env: env
  # Expects =mysql_env=
  config.vm.provision :shell, name: "install-mysql", path: "vagrant/install-mysql.sh", env: env

  # rbenv
  config.vm.provision :shell, name: "add-user-to-staff-group", inline: "sudo usermod -a -G staff vagrant"
  config.vm.provision :shell, name: "install-rbenv", path: "vagrant/install-rbenv.sh", env: env
  config.vm.provision :file, source: "vagrant/rbenv-vars.sh", destination: "/tmp/rbenv-vars.sh"
  config.vm.provision :shell, inline: "mv /tmp/rbenv-vars.sh /etc/profile.d/"
  # config.vm.provision :shell, name: "install-ruby", path: "vagrant/install-ruby-rbenv.sh", env: env, privileged: false
  config.vm.provision :shell, name: "rbenv-install", inline: "rbenv install 2.4.2", env: env
  config.vm.provision :shell, name: "rbenv-global", inline: "rbenv global 2.4.2", env: env
  config.vm.provision :shell, name: "gem-bundle", inline: "gem install bundle --no-ri --no-rdoc", env: env

  # Install gems
  config.vm.provision :shell, name: "bundle", inline: "cd /vagrant && bundle", run: :always, privileged: false

  # Run app
  # config.vm.provision :shell, name: "run", inline: "cd /vagrant && god -c sinatra.god", run: :always, privileged: false

  # Install god service
  config.vm.provision :shell, name: "install-god-service", inline: "cp /vagrant/systemd/system/god.service /etc/systemd/system/god.service"

  # Run god (hence app)
  config.vm.provision :shell, name: "start-daemon", path: "vagrant/start-daemon.sh", run: :always

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
