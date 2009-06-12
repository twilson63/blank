set :application, "blank"
set :repository, "git@github.com:twilson63/#{application}.git"

set :server_name, Capistrano::CLI.ui.ask("server name: ")

set :scm, "git"
set :checkout, "export"
set :deploy_via, :remote_cache
set :branch, "master"
set :base_path, "/home/deploy/apps"
set :deploy_to, "/home/deploy/apps/#{application}"

set :apache_site_folder, "/etc/apache2/sites-enabled"

set :user, 'deploy'
set :runner, 'deploy'
set :use_sudo, true
set :keep_releases, 2 
#set :port, 30000

role :web, server_name
role :app, server_name
role :db,  server_name, :primary => true


ssh_options[:paranoid] = false
default_run_options[:pty] = true

after "deploy:setup", "init:set_permissions"
after "deploy:setup", "init:database_yml"

after "deploy:setup", "init:create_vhost"
after "deploy:setup", "init:enable_site"

after "deploy:update_code", "config:copy_shared_configurations"


# Overrides for Phusion Passenger
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  desc "Get Production log"
  task :tail, :roles => :app do
    run "tail -n 1000 #{current_path}/sinatra.log"
  end


end

# Configuration Tasks
namespace :config do
  desc "copy shared configurations to current"
  task :copy_shared_configurations, :roles => [:app] do
    %w[database.yml].each do |f|
      run "ln -nsf #{shared_path}/config/#{f} #{release_path}/config/#{f}"
    end
  end
end

namespace :init do

  desc "setting proper permissions for deploy user"
  task :set_permissions do
    sudo "chown -R deploy #{base_path}/#{application}"
  end


  desc "create database.yml"
  task :database_yml do
    set :db_user, Capistrano::CLI.ui.ask("database user: ")
    set :db_pass, Capistrano::CLI.password_prompt("database password: ")
    database_configuration = %(
production:
  adapter: mysql
  encoding: utf8
  database: rworld
  host: localhost
  username: #{db_user}
  password: #{db_pass}
  socket: /var/run/mysqld/mysqld.sock

)
    run "mkdir -p #{shared_path}/config"
    put database_configuration, "#{shared_path}/config/database.yml"
  end
    

  desc "create vhost file"
  task :create_vhost do

    vhost_configuration = %(
<VirtualHost *:80>
  ServerName www.projectx.jackhq.com
  DocumentRoot #{base_path}/#{application}/current/public

</VirtualHost>
)

    put vhost_configuration, "#{shared_path}/config/apache_site.conf"
    #run "sudo /etc/init.d/apache2 reload"

  end


  desc "enable site"
  task :enable_site do
    sudo "ln -nsf #{shared_path}/config/apache_site.conf #{apache_site_folder}/#{application}"

  end
  
  task :set_key do
    set :api_key, Capistrano::CLI.ui.ask("api key: ")
    put "export API_KEY=#{api_key}", "/home/deploy/.bashrc"
  end


end
