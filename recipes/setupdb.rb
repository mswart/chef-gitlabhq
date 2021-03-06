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

bash 'create-postgresql-user' do
  user 'postgres'
  code "psql --command=\"CREATE ROLE #{node['gitlabhq']['user']} NOSUPERUSER CREATEDB NOCREATEROLE INHERIT LOGIN\"; psql --command=\"CREATE DATABASE #{node['gitlabhq']['database']['database']} OWNER #{node['gitlabhq']['user']} ENCODING \'utf8\'\" || true"
  only_if { node['gitlabhq']['database']['adapter'] == 'postgresql' }
end
