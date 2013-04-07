#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
#load path
require 'rvm/capistrano'
require 'bundler/capistrano'

set :rvm_type, :system
set :repository,  "git@github.com:dasibre/afrails.git"
set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
 set :branch, "master"

set :application, "afrails"
role :web, "184.106.136.67"                         	 # Your HTTP server, Apache/etc
role :app, "184.106.136.67"                          # This may be the same as your `Web` server
role :db,  "184.106.136.67", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :user, "deploy"
set :deploy_to, "/var/zpanel/hostdata/zadmin/public_html/afrails"
set :deploy_via, :remote_cache
set :use_sudo, false

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
  namespace :deploy do
   desc "Tell Passenger to restart app"
   #task :start do ; end
   #task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end

   desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
  end
  
  desc "Sync the public/assets directory."
  task :assets do
    system "rsync -vr --exclude='.DS_Store' public/assets #{user}@#{application}:#{shared_path}/"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'