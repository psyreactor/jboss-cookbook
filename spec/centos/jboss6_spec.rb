require_relative '../spec_helper'

describe 'jboss::jboss6 on Centos 6.5' do
  let(:chef_run) do
    ChefSpec::Runner.new(
      :platform => 'centos',
      :version => '6.5'
      ) do |node|
      node.set[:jboss][:version] = '6.2.0'
    end.converge('jboss::jboss6')
  end

  let(:jboss_init) { chef_run.template('/etc/init.d/app') }
  let(:jboss_standalone) { chef_run.template('/opt/app/bin/standalone.conf') }

  before do
    stub_command('test -h /var/log/jboss-as/app').and_return(true)
    stub_command('test -h /opt/app/standalone/log').and_return(false)
    stub_command('grep admin /opt/app/standalone/configuration/mgmt-users.properties').and_return(false)
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
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/jboss-eap-6.2.0.zip")
  end

  it 'extract jboss' do
    expect(chef_run).to run_execute('jboss_extract')
  end

  it 'move directory to detination path' do
    expect(chef_run).to run_execute('jboss_install_path')
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
    expect(chef_run).to create_template('/etc/jboss-as/app.conf')
  end

  it 'delete symlink to log jboss config file' do
    expect(chef_run).to delete_link('/var/log/jboss-as/app')
  end

  it 'creates log directory for jboss' do
    expect(chef_run).to create_directory('/var/log/jboss-as/app')
  end

  it 'delete default log directory for jboss' do
    expect(chef_run).to delete_directory('/opt/app/standalone/log')
  end

  it 'create symlink to log jboss config file' do
    expect(chef_run).to create_link('/opt/app/standalone/log')
  end

  it 'add admin user for jboss' do
    expect(chef_run).to run_execute('add_admin_user')
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

  it 'create standalone conf for jboss' do
    expect(chef_run).to create_template('/opt/app/bin/standalone.conf')
  end

  it 'sends a notification to services' do
    expect(jboss_standalone).to notify('service[app]').to(:restart)
  end

end
