#
# Cookbook Name:: gitlabhq
# Attributes:: default
#
# Author:: Malte Swart (<chef@malteswart.de>)
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

default['gitlabhq']['dependencies'] = %w{libicu-dev}

default['gitlabhq']['user'] = 'git'
default['gitlabhq']['group'] = 'git'
default['gitlabhq']['home'] = '/home/git'
default['gitlabhq']['self_signed_cert'] = false
default['gitlabhq']['auth_file'] = '.ssh/authorized_keys'
default['gitlabhq']['repos_path'] = 'repositories'

default['gitlabhq']['shell-url'] = 'git://github.com/gitlabhq/gitlab-shell.git'
default['gitlabhq']['shell-ref'] = 'master'

default['gitlabhq']['rvm-user'] = nil # system installation
default['gitlabhq']['ruby'] = '1.9.3-p327'
default['gitlabhq']['gemset'] = 'gitlab'

default['gitlabhq']['repo-url'] = 'git://github.com/gitlabhq/gitlabhq.git'
default['gitlabhq']['repo-ref'] = '5-0-stable'


# gitlab.yml

default['gitlabhq']['host'] = node['fqdn']
default['gitlabhq']['port'] = 80
default['gitlabhq']['https'] = false

default['gitlabhq']['relative_url_root'] = nil

default['gitlabhq']['email_from'] = "gitlab@#{node['fqdn']}"
default['gitlabhq']['support_from'] = "gitlab@#{node['fqdn']}"
default['gitlabhq']['default_projects_limit'] = 10
default['gitlabhq']['signup_enabled'] = false
default['gitlabhq']['username_changing_enabled'] = true

default['gitlabhq']['redmine_project_url'] = nil
default['gitlabhq']['redmine_issues_url'] = nil

default['gitlabhq']['gravatar'] = true
default['gitlabhq']['gravatar_plain_url'] = 'http://www.gravatar.com/avatar/%{hash}?s=%{size}&d=mm'
default['gitlabhq']['gravatar_secure_url'] = 'https://secure.gravatar.com/avatar/%{hash}?s=%{size}&d=mm'

default['gitlabhq']['upload_pack'] = true
default['gitlabhq']['receive_pack'] = true
