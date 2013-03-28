#
# Cookbook Name:: gitlabhq
# Recipe:: default
#
# Copyright 2013, Malte Swart
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


# 1. create git user and group for gitlab and repositories
# --------------------------------------------------------
group node['gitlabhq']['group'] do
  system true
end

user node['gitlabhq']['user'] do
  gid node['gitlabhq']['group']
  system true
  comment 'GitLab'
  home node['gitlabhq']['home']
  supports :manage_home => true
end


# 2. install gitlab-shell
# -----------------------

repos_path = File.expand_path node['gitlabhq']['repos_path'], node['gitlabhq']['home']
auth_file = File.expand_path node['gitlabhq']['auth_file'], node['gitlabhq']['home']

git ::File.join(node['gitlabhq']['home'], 'gitlab-shell') do
  repository node['gitlabhq']['shell-url']
  reference node['gitlabhq']['shell-ref']
  user node['gitlabhq']['user']
  group node['gitlabhq']['group']
  action :sync
end

template ::File.join(node['gitlabhq']['home'], 'gitlab-shell', 'config.yml') do
  source "gitlab-shell-config.yml.erb"
  owner node['gitlabhq']['user']
  group node['gitlabhq']['group']
  mode 00644
  variables :options => node['gitlabhq'], :repos_path => repos_path, :auth_file => auth_file
end

# do setups of bin/install

directory repos_path do
  user node['gitlabhq']['user']
  recursive true
  mode 00770
  action :create
end

directory ::File.dirname(auth_file) do
  user node['gitlabhq']['user']
  recursive true
  action :create
end

file auth_file do
  user node['gitlabhq']['user']
  action :touch
end

bash 'fix repo modes' do
  user node['gitlabhq']['user']
  code <<-EOC
  chmod -R ug+rwX,o-rwx #{repos_path}
  find #{repos_path} -type d -print0 | xargs -0 chmod g+s
  EOC
end


# 3. install ruby env via rvm
# ---------------------------

include_recipe 'rvm::default'

rvm_environment "#{node['gitlabhq']['ruby']}@#{node['gitlabhq']['gemset']}" do
  user node['gitlabhq']['rvm-user']
end

rvm_wrapper 'gitlab' do
  ruby_string "#{node['gitlabhq']['ruby']}@#{node['gitlabhq']['gemset']}"
  binary 'bundle'
end


# 4. install dependencies
# -----------------------

node['gitlabhq']['dependencies'].each do |pkg|
  package pkg do
    action :install
  end
end


# 5. deploy gitlab
# ----------------

# create shared/config directory to be able to create config files
%w(gitlab shared config).inject(node['gitlabhq']['home']) do |path, dir|
  path = ::File.join path, dir
  directory path do
    user node['gitlabhq']['user']
    group node['gitlabhq']['group']
  end
  path
end

# create database.yml configuration file (needed for migration)
template ::File.join(node['gitlabhq']['home'], 'gitlab', 'shared', 'config', 'database.yml') do
  source 'database.yml.erb'
  user node['gitlabhq']['user']
  group node['gitlabhq']['group']
  variables :database => node['gitlabhq']['database']
  backup false
end

# create gitlab config
template ::File.join(node['gitlabhq']['home'], 'gitlab', 'shared', 'config', 'gitlab.yml') do
  source 'gitlab.yml.erb'
  user node['gitlabhq']['user']
  group node['gitlabhq']['group']
  variables :options => node['gitlabhq'], :repos_path => repos_path
  backup false
end

# deploy application, deep improvement
deploy_revision ::File.join(node['gitlabhq']['home'], 'gitlab') do
  repository node['gitlabhq']['repo-url']
  revision node['gitlabhq']['repo-ref']

  environment 'RAILS_ENV' => 'production'

  keep_releases 2
  #rollback_on_error true

  user node['gitlabhq']['user']
  group node['gitlabhq']['group']

  before_migrate do
    bash "Bundle install and assets precompile" do
      cwd release_path
      user node['gitlabhq']['user']
      group node['gitlabhq']['group']
      code %{
         gitlab_bundle install --deployment --path "#{node['gitlabhq']['home']}/gitlab/shared/bundle" --without development test
      }
    end
  end

  migrate true
  migration_command 'gitlab_bundle exec rake db:migrate --trace'

  restart_command 'touch tmp/restart.txt'
end
