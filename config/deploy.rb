#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
#load path
require 'rvm/capistrano'
require 'bundler/capistrano'

server "184.106.136.67", :web, :app, :db, primary: true

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :rvm_type, :user 

set :repository, "git://github.com/dasibre/afrails.git"
set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, "master"

set :application, "afrails"
set :user, "deploy"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

# if you want to clean up old releases on each deploy uncomment this:
 after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
  namespace :deploy do
    %w[start stop restart].each do |command|
      desc "#{command} unicorn server"
      task command, roles: :app, except: {no_release: true} do
        run "/etc/init.d/unicorn_#{application} #{command}"
      end
   #desc "Tell Passenger to restart app"
   #task :start do ; end
   #task :stop do ; end
   #task :restart, :roles => :app, :except => { :no_release => true } do
    # run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end

   task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/conf.d/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
   end
   after "deploy:setup", "deploy:setup_config"

   task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  #desc "Symlink shared configs and folders on each release."
  #task :symlink_shared do
   # run "mkdir -p #{shared_path}/config"
    #put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    #run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    #run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
  #end

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
  
  #desc "Sync the public/assets directory."
  #task :assets do
   # system "rsync -vr --exclude='.DS_Store' public/assets #{user}@#{application}:#{shared_path}/"
  #end
end

#after 'deploy:update_code', 'deploy:symlink_shared'
