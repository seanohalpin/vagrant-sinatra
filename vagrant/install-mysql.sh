#!/usr/bin/env bash
# Note: run this script as root
# * Set up mysql server
# ** Expected env vars
# | Var                 | Example   |
# |---------------------+-----------|
# | MYSQL_ROOT_PASSWORD | root123   |
# | MYSQL_APP_HOST      | localhost |
# | MYSQL_APP_DB        | appdb     |
# | MYSQL_APP_USERNAME  | appuser   |
# | MYSQL_APP_PASSWORD  | user123   |
# ** Set mysql root password for automatic installation
debconf-set-selections <<< "mysql-server mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${MYSQL_ROOT_PASSWORD}"
# ** Install mysql and client libs
apt-get install -y mysql-server mysql-client libmysqlclient-dev
# ** mysql cmd
MYSQL_CMD="mysql -u root --password=${MYSQL_ROOT_PASSWORD}"
# ** Replicate mysql_secure_installation
# =mysql_secure_installation= is not straightforward to automate, so
# we replicate what it does here
$MYSQL_CMD <<-EOF
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOF

# ** Create database and add application user
$MYSQL_CMD <<-EOF
CREATE DATABASE ${MYSQL_APP_DB};
CREATE USER '${MYSQL_APP_USERNAME}'@'${MYSQL_APP_HOST}' IDENTIFIED BY '${MYSQL_APP_PASSWORD}';
GRANT ALL ON ${MYSQL_APP_DB}.* TO '${MYSQL_APP_USERNAME}'@'${MYSQL_APP_HOST}';
FLUSH PRIVILEGES;
EOF
