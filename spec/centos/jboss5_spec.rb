require_relative '../spec_helper'

describe 'jboss::jboss5 on Centos 6.5' do
  let(:chef_run) do
    ChefSpec::Runner.new(
      :platform => 'centos',
      :version => '6.5'
      ) do |node|
      node.set[:jboss][:version] = '5.2.0'
    end.converge('jboss::jboss5')
  end

  let(:jboss_init) { chef_run.template('/etc/init.d/app') }

  before do
    stub_command('test -h /etc/jboss-as/app').and_return(false)
    stub_command('test -h /var/log/jboss-as/app').and_return(true)
    stub_command('test -h /opt/jboss-as/server/app/log').and_return(false)
  end

  it 'installs a unzip package' do
    expect(chef_run).to install_package('install_unzip')
  end

  it 'creates a user for jboss' do
    expect(chef_run).to create_user('jboss')
  end

  it 'creates a group for jboss user' do
    expect(chef_run).to create_group('jboss')
  end

  it 'download a jboss package' do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/jboss-eap-5.2.0.zip")
  end

  it 'extract jboss' do
    expect(chef_run).to run_execute('jboss_extract')
  end

  it 'move directory to detination path' do
    expect(chef_run).to run_execute('jboss_install_path')
  end

  it 'copy profile directory to detination path' do
    expect(chef_run).to run_execute('create_profile')
  end

  it 'change owner jboss' do
    expect(chef_run).to run_execute('jboss_owner')
  end

  it 'creates config directory for jboss' do
    expect(chef_run).to create_directory('/etc/jboss-as')
  end

  it 'creates pid directory for jboss' do
    expect(chef_run).to create_directory('/var/run/jboss-as')
  end

  it 'created jboss config file' do
    expect(chef_run).to create_template('/opt/jboss-as/server/app/conf/run.conf')
  end

  it 'delete symlink to log jboss config file' do
    expect(chef_run).to delete_link('/var/log/jboss-as/app')
  end

  it 'creates log directory for jboss' do
    expect(chef_run).to create_directory('/var/log/jboss-as/app')
  end

  it 'delete default log directory for jboss' do
    expect(chef_run).to delete_directory('/opt/jboss-as/server/app/log')
  end

  it 'create symlink to log jboss config file' do
    expect(chef_run).to create_link('/opt/jboss-as/server/app/log')
  end

  it 'create symlink to config file' do
    expect(chef_run).to create_link('/etc/jboss-as/app')
  end

  it 'declare jboss service' do
    execute = chef_run.service('app')
    expect(execute).to do_nothing
  end

  it 'create service script jboss' do
    expect(chef_run).to create_template('/etc/init.d/app')
  end

  it 'sends a notification to services' do
    expect(jboss_init).to notify('service[app]').to(:enable)
    expect(jboss_init).to notify('service[app]').to(:start)
  end

end
