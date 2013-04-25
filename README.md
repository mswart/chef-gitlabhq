chef-gitlabhq
=============

[![Build Status](https://travis-ci.org/mswart/chef-gitlabhq.png)](https://travis-ci.org/mswart/chef-gitlabhq)

**This cookbook is currently under development and designing! Because the README is written before the feature is implemented, some points could be missing.**


Description
-----------


Recipes
-------

* `default`: installs gitlabhq
* `setupdb`: shortcut to create the needed database user. Currently only postgresql is supported if the server runs on the same machine and `postgres` is postgresql superuser.



Attributes
----------

### User

* `node['gitlabhq']['user']` (`git`): User for application and ssh access. If you use another user than `git`, the git urls with ssh access change also.
* `node['gitlabhq']['group']` (`git`)
* `node['gitlabhq']['home']` (`/home/git`): Home directory for gitlab and per default all repositories
* `node['gitlabhq']['auth_file']` (`.ssh/authorized_keys`): Path to ssh authorized key file of git user. Absolute or relative paths to git home directory supported. Needs only adjustments if the ssh server has changes settings.
* `node['gitlabhq']['repos_path']` (`repositories`): Path to repositories. Absolute or relative paths to git home directory supported.

### Interpreter
* `node['gitlabhq']['rvm-user']` (`nil`): Set this to git if rvm is installed as user rvm for git. `nil` means system-wide installation
* `node['gitlabhq']['ruby']` (`1.9.3-p327`): Ruby version
* `node['gitlabhq']['gemset']` (`gitlab`): Gemset name to separate gems of gitlab from other ruby software

### source options

* `node['gitlabhq']['repo-url']` (`git://github.com/gitlabhq/gitlabhq.git`)
* `node['gitlabhq']['repo-ref']` (`5-1-stable`)
* `node['gitlabhq']['shell-url']` (`git://github.com/gitlabhq/gitlab-shell.git`)
* `node['gitlabhq']['shell-ref']` (`master`)

### http options

* `node['gitlabhq']['self_signed_cert']` (`false`): Uses the server a self sign certificate (or a unknown CA). Active this option to deactivate certificate validation.
* `node['gitlabhq']['host']` (fqdn)
* `node['gitlabhq']['port']` (`80`)
* `node['gitlabhq']['https']` (`false`)
* `node['gitlabhq']['relative_url_root']` (`nil`): Specify this to run gitlabhq inside a subdirectory - e.g. `/gitlab`. `nil` means no subdirectory.

### gitlab.yml

* `node['gitlabhq']['email_from']` (`gitlab@#{node['fqdn']}`)
* `node['gitlabhq']['support_from']` (`gitlab@#{node['fqdn']}`)
* `node['gitlabhq']['default_projects_limit']` (`10`)
* `node['gitlabhq']['signup_enabled']` (`false`)
* `node['gitlabhq']['username_changing_enabled']` (`true`)

* `node['gitlabhq']['redmine_project_url']` (`nil`)
* `node['gitlabhq']['redmine_issues_url']` (`nil`)

* `node['gitlabhq']['gravatar']` (`true`)
* `node['gitlabhq']['gravatar_plain_url']` (`http://www.gravatar.com/avatar/%{hash}?s=%{size}&d=mm`)
* `node['gitlabhq']['gravatar_secure_url']` (`https://secure.gravatar.com/avatar/%{hash}?s=%{size}&d=mm`)

* `node['gitlabhq']['upload_pack']` (`true`)
* `node['gitlabhq']['receive_pack']` (`true`)

### database.yml

generated from `node['gitlabhq']['database']`. e.g.

* `node['gitlabhq']['database']['adapter'] = 'postgresql'` for postgresql


License and Author
------------------

Author:: Malte Swart (<chef@malteswart.de>)
Copyright:: 2013, Malte Swart

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
