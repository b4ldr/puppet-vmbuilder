# frozen_string_literal: true

require 'spec_helper'

describe 'vmbuilder' do
  let(:title) { 'vmbuilder' }
  let(:params) { {} }
  let(:ini_settings) do
    {
      'arch'       => 'amd64',
      'domain'     => 'example.com',
      'mask'       => '255.255.255.0',
      'net'        => '192.0.2.0',
      'name'       => 'ubuntu',
      'username'   => 'ubuntu',
      'pass'       => 'ubuntu'
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      # cant seem to set this in default_module_facts
      let(:facts) do
        facts.merge!(
          os: {
            'distro' => { 'codename' => 'xenial' },
            'architecture' => 'amd64'
          }
        )
      end

      # it { pp catalogue.resources }
      describe 'check default config' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('python-vm-builder') }
        it do
          is_expected.to contain_file('/etc/vmbuilder.cfg').with_ensure('file')
        end
        it do
          ini_settings.each_pair do |setting, value|
            is_expected.to contain_ini_setting(
              "/etc/vmbuilder.cfg [DEFAULT] #{setting}"
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: setting,
              value: value,
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        %w[bcast gw dns firstboot firstlogin execscript].each do |setting|
          it do
            is_expected.to contain_ini_setting(
              "/etc/vmbuilder.cfg [DEFAULT] #{setting}"
            ).with(
              ensure: 'absent',
              section: 'DEFAULT',
              setting: setting,
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
      end
      describe 'Change Defaults' do
        context 'package' do
          before { params.merge!(package: 'foobar') }
          it { is_expected.to compile }
          it { is_expected.to contain_package('foobar') }
        end
        context 'conf_file' do
          before { params.merge!(conf_file: '/foo/bar') }
          it { is_expected.to compile }
          it { is_expected.to contain_ini_setting('/foo/bar [kvm] bridge') }
          it { is_expected.to contain_ini_setting('/foo/bar [kvm] cpus') }
          it { is_expected.to contain_ini_setting('/foo/bar [kvm] libvirt') }
          it { is_expected.to contain_ini_setting('/foo/bar [kvm] mem') }
          it { is_expected.to contain_ini_setting('/foo/bar [kvm] network') }
          it { is_expected.to contain_ini_setting('/foo/bar [kvm] virtio_net') }
          it { is_expected.to contain_ini_setting('/foo/bar [ubuntu] addpkg') }
          it { is_expected.to contain_ini_setting('/foo/bar [ubuntu] components') }
          it { is_expected.to contain_ini_setting('/foo/bar [ubuntu] flavour') }
          it { is_expected.to contain_ini_setting('/foo/bar [ubuntu] removepkg') }
          it { is_expected.to contain_ini_setting('/foo/bar [ubuntu] suite') }
          it do
            is_expected.to contain_file('/foo/bar').with_ensure('file')
          end
          it do
            ini_settings.each_pair do |setting, value|
              is_expected.to contain_ini_setting(
                "/foo/bar [DEFAULT] #{setting}"
              ).with(
                ensure: 'present',
                section: 'DEFAULT',
                setting: setting,
                value: value,
                path: '/foo/bar'
              )
            end
          end
          %w[bcast gw dns firstboot firstlogin execscript].each do |setting|
            it do
              is_expected.to contain_ini_setting(
                "/foo/bar [DEFAULT] #{setting}"
              ).with(
                ensure: 'absent',
                section: 'DEFAULT',
                setting: setting,
                path: '/foo/bar'
              )
            end
          end
        end
        context 'command' do
          before { params.merge!(command: '/foo/bar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_arch' do
          before { params.merge!(default_arch: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [DEFAULT] arch'
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: 'arch',
              value: 'foobar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_domain' do
          before { params.merge!(default_domain: 'foo.bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [DEFAULT] domain'
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: 'domain',
              value: 'foo.bar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_network' do
          before { params.merge!(default_network: '192.0.2.42') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [DEFAULT] net'
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: 'net',
              value: '192.0.2.42',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_netmask' do
          before { params.merge!(default_netmask: '255.255.255.42') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [DEFAULT] mask'
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: 'mask',
              value: '255.255.255.42',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_broadcast' do
          before { params.merge!(default_broadcast: '192.0.2.42') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [DEFAULT] bcast'
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: 'bcast',
              value: '192.0.2.42',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_gateway' do
          before { params.merge!(default_gateway: '192.0.2.42') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [DEFAULT] gw'
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: 'gw',
              value: '192.0.2.42',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_name' do
          before { params.merge!(default_name: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [DEFAULT] name'
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: 'name',
              value: 'foobar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_username' do
          before { params.merge!(default_username: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [DEFAULT] username'
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: 'username',
              value: 'foobar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_password' do
          before { params.merge!(default_password: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [DEFAULT] pass'
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: 'pass',
              value: 'foobar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_dns' do
          before { params.merge!(default_dns: '192.0.2.53') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [DEFAULT] dns'
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: 'dns',
              value: '192.0.2.53',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_firstboot' do
          before { params.merge!(default_firstboot: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [DEFAULT] firstboot'
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: 'firstboot',
              value: '/foo/bar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_firstlogin' do
          before { params.merge!(default_firstlogin: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [DEFAULT] firstlogin'
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: 'firstlogin',
              value: '/foo/bar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_execscript' do
          before { params.merge!(default_execscript: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [DEFAULT] execscript'
            ).with(
              ensure: 'present',
              section: 'DEFAULT',
              setting: 'execscript',
              value: '/foo/bar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
      end
      describe 'check bad type' do
        context 'package' do
          before { params.merge!(package: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'conf_file' do
          before { params.merge!(conf_file: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'command' do
          before { params.merge!(command: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_arch' do
          before { params.merge!(default_arch: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_domain' do
          before { params.merge!(default_domain: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_network' do
          before { params.merge!(default_network: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_netmask' do
          before { params.merge!(default_netmask: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_broadcast' do
          before { params.merge!(default_broadcast: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_gateway' do
          before { params.merge!(default_gateway: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_name' do
          before { params.merge!(default_name: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_username' do
          before { params.merge!(default_username: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_password' do
          before { params.merge!(default_password: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'hypervisors' do
          before { params.merge!(hypervisors: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'distros' do
          before { params.merge!(distros: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_dns' do
          before { params.merge!(default_dns: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_firstboot' do
          before { params.merge!(default_firstboot: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_firstlogin' do
          before { params.merge!(default_firstlogin: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_execscript' do
          before { params.merge!(default_execscript: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
      end
    end
  end
end
