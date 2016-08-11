# Make sure the Apt package lists are up to date, so we're downloading versions that exist.
cookbook_file "apt-sources.list" do
  path "/etc/apt/sources.list"
end
execute 'apt_update' do
  command 'sudo apt-get update'
end

# Base configuration recipe in Chef.
package "wget"
package "ntp"

cookbook_file "ntp.conf" do
  path "/etc/ntp.conf"
end

execute 'ntp_restart' do
  command 'service ntp restart'
end

# Add config for ruby-dev, sqlite3, libsqlite3-dev, zlib1g-dev, nodejs.
package "ruby-dev"
# package "sqlite3"
package "libsqlite3-dev"
package "zlib1g-dev"
package "nodejs"
package "curl"
package "git-core"
package "libpq-dev"
package "nginx"
package "postgresql-contrib"
package "postgresql"

# Needed for passenger install
package "build-essential"
package "libcurl4-openssl-dev"
package "libapr1-dev"
package "libaprutil1-dev"



# Increase VM size for Passenger
#execute 'Increase VM size' do
#	command 'sudo dd if=/dev/zero of=/swap bs=1M count=1024'
#	cwd '/home/vagrant/project/polling'
#	user 'vagrant'
#end
#execute 'Swap1' do
#	command 'sudo mkswap /swap'
#	cwd '/home/vagrant/project/polling'
#	user 'vagrant'
#end
#execute 'Swap2' do
#	command 'sudo swapon /swap'
#	cwd '/home/vagrant/project/polling'
#	user 'vagrant'
#end	

#http://stackoverflow.com/questions/15477740/bad-gateway-errors-at-load-on-nginx-unicorn-rails-3-app
# Change OS limits => Attempt fix for 502 Bad Gateway error
execute 'Increase Limit' do
	command 'sudo cp /vagrant/chef/cookbooks/baseconfig/files/default/sysctl.conf /etc/sysctl.conf'
end
execute 'Set ulimit' do	
	command 'sudo sh -c "ulimit -n"'
end

# Initiate postgres, username = vagrant
execute 'db_setup' do
  command 'sudo -u postgres createuser -s vagrant | sudo -u postgres psql'
end

cookbook_file "apt-sources.list" do
  path "/etc/apt/sources.list"
end


# Get gems
execute 'rubygems-update install' do
    # https://bbs.archlinux.org/viewtopic.php?pid=893218#p893218
	command 'gem install rubygems-update --conservative'
end
execute 'update ruby gems' do	
	command 'update_rubygems'
end
execute 'bundler install' do	
	command 'gem install bundler --conservative' # ' #; gem install byebug -v "8.2.2";'
end
execute 'Install Bundle' do
	command 'bundle install'
	cwd '/home/vagrant/project/polling'
	user 'vagrant'
end


# SET SECRET_KEY_BASE FOR PRODUCTION
#env 'SECRET_KEY_BASE' do
#	value '710e511e00aa961fd24798875aff1f7d674caf9c7ed45abc8c92cf2875e89069af2424856f4710c1817e33e17cee8c7c7b9dc8d5e7eeea8160290648e5cf71cd'
#end
	
#execute 'Set Secret Key' do	
#	command 'env SECRET_KEY_BASE="710e511e00aa961fd24798875aff1f7d674caf9c7ed45abc8c92cf2875e89069af2424856f4710c1817e33e17cee8c7c7b9dc8d5e7eeea8160290648e5cf71cd" ruby -e "puts ENV[\'SECRET_KEY_BASE\']"'
#	cwd '/home/vagrant/project/polling'
#	user 'vagrant'
#end


#Set up Passenger for nginx
#execute 'Install Passenger' do
#	command 'sudo passenger-install-nginx-module'
#	cwd '/home/vagrant/project/polling'
#	user 'vagrant'
#end

# Set up Unicorn
#execute 'set_unicorn' do
#  command 'sudo cp /vagrant/chef/cookbooks/baseconfig/files/default/unicorn_rails /vagrant/polling/shared/etc/init.d/unicorn_rails'
#end

cookbook_file "workaround-vagrant-bug-6074.conf" do
  path "/etc/init/workaround-vagrant-bug-6074.conf"
  mode 0644
end
cookbook_file "unicorn_rails.conf" do
  path "/etc/init/unicorn_rails.conf"
  mode 0644
end

#execute 'init_unicorn_permission' do
#	command 'chmod +x /etc/init.d/unicorn_rails'
#end

#Start Unicorn service
#execute 'start_unicorn' do	
#	command 'service unicorn_rails start'
#end

# Set up Nginx
#execute 'set_conf' do
#  command 'sudo cp /vagrant/chef/cookbooks/baseconfig/files/default/nginx-default /etc/init/nginx.conf'
#end
#execute 'set_conf' do
#  command 'sudo cp /vagrant/chef/cookbooks/baseconfig/files/default/nginx-default opt/nginx/conf/nginx.conf'
#end
#execute 'Start_nginx' do
#	command 'sudo service nginx start'
#	cwd '/home/vagrant/project/polling'
#	user 'vagrant'
#end

# Give permissions on project folder
execute 'Nginx Permissions' do
	command 'sudo chmod a+x /home/vagrant/project/polling'
end

service 'nginx' do	
	action [ :enable, :start]
end
cookbook_file "nginx-default" do
  path "/etc/nginx/sites-available/default"
end
service 'nginx' do
  action [ :restart, :reload ]
end

# Postgres create db for all databases
execute 'createdb' do
	command 'rake db:create:all'
	cwd '/home/vagrant/project/polling'
	user 'vagrant'
end

# Postgres DEV
#execute 'resetdb' do
#	command 'rake db:reset'
#	cwd '/home/vagrant/project/polling'
#	user 'vagrant'
#end
#execute 'migrate' do
#	command 'rake db:migrate'
#	cwd '/home/vagrant/project/polling'
#	user 'vagrant'
#end

# Postgres PRODUCTION
execute 'resetdb' do
	command 'rake db:reset RAILS_ENV=production'
	cwd '/home/vagrant/project/polling'
	user 'vagrant'
end
execute 'migrate' do
	command 'rake db:migrate RAILS_ENV=production'
	cwd '/home/vagrant/project/polling'
	user 'vagrant'
end

# START SERVER ON DEV
#execute 'Inst. Server' do
#	command 'rails server -d -b 0.0.0.0'
#	cwd '/home/vagrant/project/polling'
#	user 'vagrant'
#end

# START SERVER ON PRODUCTION => Not Nginx, just confirm that rails is going up
#execute 'Inst. Server' do
#	command 'rails server -e production -d -b 0.0.0.0'
#	cwd '/home/vagrant/project/polling'
#	user 'vagrant'
#end

execute 'Get Assets' do
	command 'rake assets:precompile RAILS_ENV=production'
	cwd '/home/vagrant/project/polling'
	user 'vagrant'
end

service 'unicorn_rails' do
  action :start
end
