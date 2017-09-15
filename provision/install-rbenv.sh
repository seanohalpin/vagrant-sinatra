#!/bin/sh
# rbenv
cd /usr/local
git clone git://github.com/sstephenson/rbenv.git rbenv
# chgrp -R staff /usr/local/rbenv
# chmod -R g+rwxXs /usr/local/rbenv
# ruby-build
cd /usr/local/rbenv
mkdir plugins
cd plugins
git clone git://github.com/sstephenson/ruby-build.git
# chgrp -R staff ruby-build
# chmod -R g+rwxs ruby-build

chgrp -R staff /usr/local/rbenv
chmod -R g+rwxXs /usr/local/rbenv
