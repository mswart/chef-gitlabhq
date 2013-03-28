require 'chefspec'

describe 'gitlabhq::default' do
  let(:chef_runner)  do
    ChefSpec::ChefRunner.new(
      :cookbook_path => [ '..', 'tmp/cookbooks/'],
      :platform => 'ubuntu', :version => '12.04'
    )
  end
  let(:chef_run)     { chef_runner.converge 'rvm::system', 'gitlabhq::default' }

  let(:shell_config) { '/home/git/gitlab-shell/config.yml' }
  let(:gitlab_config) { '/home/git/gitlab/shared/config/gitlab.yml' }
  let(:database_config) { '/home/git/gitlab/shared/config/database.yml' }

  it 'should create system user' do
    expect(chef_run).to create_user 'git'
  end

  context 'should install gitlab-shell:' do
    it 'create config' do
      expect(chef_run).to create_file shell_config
      pending 'make own test work'
      expect(chef_run.file(shell_config)).to be_owned_by('git')
    end

    it 'has correct user and home setting' do
      expect(chef_run).to create_file_with_content shell_config, 'user: git'
      expect(chef_run).to create_file_with_content shell_config, '/home/git'
    end

    it 'activation of certification checks per default' do
      expect(chef_run).to create_file_with_content shell_config, 'self_signed_cert: false'
    end

    it 'support deactivation of certification checks' do
      chef_runner.node.set['gitlabhq']['self_signed_cert'] = true
      expect(chef_run).to create_file_with_content shell_config, 'self_signed_cert: true'
    end

    it 'should resolve relative pathes of repository path' do
      expect(chef_run).to create_file_with_content shell_config, 'repos_path: "/home/git/repositories"'
    end

    it 'should support absolute pathes of repository path' do
      chef_runner.node.set['gitlabhq']['repos_path'] = '/var/lib/git/repositories'
      expect(chef_run).to create_file_with_content shell_config, 'repos_path: "/var/lib/git/repositories"'
    end

    it 'should resolve relative pathes of auth_file' do
      expect(chef_run).to create_file_with_content shell_config, 'auth_file: "/home/git/.ssh/authorized_keys"'
    end

    it 'should support absolute pathes of auth_file' do
      chef_runner.node.set['gitlabhq']['auth_file'] = '/var/keys/git'
      expect(chef_run).to create_file_with_content shell_config, 'auth_file: "/var/keys/git"'
    end
  end

  context 'should support other user name:' do
    before do
      chef_runner.node.set['gitlabhq']['user'] = 'hans'
    end

    it 'create other user' do
      expect(chef_run).to create_user 'hans'
    end

    xit 'as owner for gitlab shell' do
      expect(chef_run.file shell_config).to be_owned_by 'hans'
    end

    it 'should configure gitlab to use other user' do
      expect(chef_run).to create_file_with_content gitlab_config, 'user: hans'
    end
  end

  context 'should install dependencies:' do
    it 'libicu-dev' do
      expect(chef_run).to install_package 'libicu-dev'
    end
  end

  context 'configure gitlab' do
    it 'should support absolute pathes of auth_file' do
      chef_runner.node.set['gitlabhq']['auth_file'] = '/var/keys/git'
      expect(chef_run).to create_file_with_content shell_config, 'user: '
    end
  end
end
