name              'gitlabhq'
maintainer        'Malte Swart'
maintainer_email  'chef@malteswart.de'
license           'Apache 2.0'
description       'Cookbook to install gitlabhq and integrate into your infrastructure'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.1.0'

%w{ ubuntu }.each do |os|
  supports os
end
