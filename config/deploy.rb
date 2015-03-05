lock "3.3.5"
set :application, 'sl2017'
set :repo_url, 'git@github.com:wdiechmann/sl2017.git'

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

# default value

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :deploy_to, "/var/www/#{fetch(:application)}"
set :deploy_user, "oxenserver"
set :scm, :git
set :myself, `whoami`.chomp # if more users have the same user on the server,

set :format, :pretty
set :log_level, :info
#set :pty, true

set :linked_files, %w{config/database.yml .env}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# PUMA settings
# set :puma_rackup, -> { File.join(current_path, 'config.ru') }
# set :puma_state, "#{shared_path}/tmp/pids/puma.state"
# set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
# set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
# set :puma_conf, "#{shared_path}/puma.rb"
# set :puma_access_log, "#{shared_path}/log/puma_error.log"
# set :puma_error_log, "#{shared_path}/log/puma_access.log"
# set :puma_role, :app
# set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
# set :puma_threads, [0, 16]
# set :puma_workers, 0
# set :puma_init_active_record, true
# set :puma_preload_app, true



namespace :deploy do

  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     # Your restart mechanism here, for example:
  #     # execute :touch, release_path.join('tmp/restart.txt')
  #   end
  # end
  #
  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

  after :finishing, 'deploy:cleanup'

end
