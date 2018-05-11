# frozen_string_literal: true

require 'spec_helper'

describe 'vmbuilder::host' do
  let(:title) { 'test.example.com' }

  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      ip: '192.0.2.10',
      # hypervisor: "kvm",
      # distro: "ubuntu",
      # hostname: :undef,
      # destination: :undef,
      # arch: :undef,
      # domain: :undef,
      # network: :undef,
      # netmask: :undef,
      # broadcast: :undef,
      # gateway: :undef,
      # realname: :undef,
      # username: :undef,
      # password: :undef,
      # dns: :undef,
      # firstboot: :undef,
      # firstlogin: :undef,
      # execscript: :undef,

    }
  end

  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  let (:pre_condition) { "include vmbuilder" }
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge!(
          os: {
            'distro' => { 'codename' => 'xenial' },
            'architecture' => 'amd64'
          }
        )
      end
      let(:destdir) { '/var/lib/libvirt/images/ubuntu-kvm' }

      describe 'check default config' do
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_exec(
            'vmbuilder::host create test.example.com'
          ).with_command(
            %r{/usr/bin/vmbuilder kvm ubuntu --ip=192.0.2.10 --hostname=test.example.com -d #{destdir}\s+$}
          ).with_creates(destdir)
        end
      end
      describe 'Change Defaults' do
        context 'ip' do
          before { params.merge!(ip: '192.0.2.42') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(
              %r{/usr/bin/vmbuilder kvm ubuntu --ip=192.0.2.42 --hostname=test.example.com -d #{destdir}\s+$}
            )
          end
        end
        context 'hostname' do
          before { params.merge!(hostname: 'foo.bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(
              %r{/usr/bin/vmbuilder kvm ubuntu --ip=192.0.2.10 --hostname=foo.bar -d #{destdir}\s+$}
            )
          end
        end
        context 'destination' do
          before { params.merge!(destination: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(
              %r{/usr/bin/vmbuilder kvm ubuntu --ip=192.0.2.10 --hostname=test.example.com -d /foo/bar\s+$}
            ).with_creates('/foo/bar')
          end
        end
        context 'arch' do
          before { params.merge!(arch: 'amd64') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(%r{--arch=amd64})
          end
        end
        context 'domain' do
          before { params.merge!(domain: 'foo.bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(%r{--domain=foo.bar})
          end
        end
        context 'network' do
          before { params.merge!(network: '192.0.2.0') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(%r{--net=192.0.2.0})
          end
        end
        context 'netmask' do
          before { params.merge!(netmask: '255.255.255.0') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(%r{--mask=255.255.255.0})
          end
        end
        context 'broadcast' do
          before { params.merge!(broadcast: '192.0.2.255') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(%r{--bcast=192.0.2.255})
          end
        end
        context 'gateway' do
          before { params.merge!(gateway: '192.0.2.254') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(%r{--gw=192.0.2.254})
          end
        end
        context 'realname' do
          before { params.merge!(realname: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(%r{--name=foobar})
          end
        end
        context 'username' do
          before { params.merge!(username: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(%r{--user=foobar})
          end
        end
        context 'password' do
          before { params.merge!(password: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(%r{--pass=foobar})
          end
        end
        context 'dns' do
          before { params.merge!(dns: '192.0.2.53') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(%r{--dns=192.0.2.53})
          end
        end
        context 'firstboot' do
          before { params.merge!(firstboot: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(%r{--firstboot=/foo/bar})
          end
        end
        context 'firstlogin' do
          before { params.merge!(firstlogin: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(%r{--firstlogin=/foo/bar})
          end
        end
        context 'execscript' do
          before { params.merge!(execscript: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_exec(
              'vmbuilder::host create test.example.com'
            ).with_command(%r{--execscript=/foo/bar})
          end
        end
      end
      describe 'check bad type' do
        context 'ip' do
          before { params.merge!(ip: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'hypervisor' do
          before { params.merge!(hypervisor: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'distro' do
          before { params.merge!(distro: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'hostname' do
          before { params.merge!(hostname: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'destination' do
          before { params.merge!(destination: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'arch' do
          before { params.merge!(arch: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'domain' do
          before { params.merge!(domain: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'network' do
          before { params.merge!(network: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'netmask' do
          before { params.merge!(netmask: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'broadcast' do
          before { params.merge!(broadcast: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'gateway' do
          before { params.merge!(gateway: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'realname' do
          before { params.merge!(realname: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'username' do
          before { params.merge!(username: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'password' do
          before { params.merge!(password: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'dns' do
          before { params.merge!(dns: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'firstboot' do
          before { params.merge!(firstboot: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'firstlogin' do
          before { params.merge!(firstlogin: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'execscript' do
          before { params.merge!(execscript: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
      end
    end
  end
end
