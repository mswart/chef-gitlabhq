require 'chefspec'

describe 'gitlabhq::default' do
  let(:chef_runner)  { ChefSpec::ChefRunner.new }
  let(:chef_run)     { chef_runner.converge 'gitlabhq::default' }

  let(:shell_config) { '/home/git/gitlab-shell/config.yml' }

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
  end
end
