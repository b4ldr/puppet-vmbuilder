# frozen_string_literal: true

require 'spec_helper'

describe 'vmbuilder::hypervisor::kvm' do
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  # This will need to get moved
  # it { pp catalogue.resources }
  let(:params) { {} }
  let(:ini_settings) do
    {
      'libvirt' => 'qemu:///system',
      'virtio_net' => true,
      'mem' => 128,
      'cpus' => 1
    }
  end

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

      describe 'check default config' do
        it { is_expected.to compile.with_all_deps }
        it do
          ini_settings.each_pair do |setting, value|
            is_expected.to contain_ini_setting(
              "/etc/vmbuilder.cfg [kvm] #{setting}"
            ).with(
              ensure: 'present',
              section: 'kvm',
              setting: setting,
              value: value,
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        %w[bridge network].each do |setting|
          it do
            is_expected.to contain_ini_setting(
              "/etc/vmbuilder.cfg [kvm] #{setting}"
            ).with(
              ensure: 'absent',
              section: 'kvm',
              setting: setting,
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
      end
      describe 'Change Defaults' do
        context 'libvirt_uri' do
          before { params.merge!(libvirt_uri: 'foo:///bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [kvm] libvirt'
            ).with(
              ensure: 'present',
              section: 'kvm',
              setting: 'libvirt',
              value: 'foo:///bar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'virtio_net' do
          before { params.merge!(virtio_net: false) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [kvm] virtio_net'
            ).with(
              ensure: 'present',
              section: 'kvm',
              setting: 'virtio_net',
              value: 'false',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_mem' do
          before { params.merge!(default_mem: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [kvm] mem'
            ).with(
              ensure: 'present',
              section: 'kvm',
              setting: 'mem',
              value: 42,
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_cpus' do
          before { params.merge!(default_cpus: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [kvm] cpus'
            ).with(
              ensure: 'present',
              section: 'kvm',
              setting: 'cpus',
              value: 42,
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_bridge' do
          before { params.merge!(default_bridge: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [kvm] bridge'
            ).with(
              ensure: 'present',
              section: 'kvm',
              setting: 'bridge',
              value: 'foobar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_network' do
          before { params.merge!(default_network: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [kvm] network'
            ).with(
              ensure: 'present',
              section: 'kvm',
              setting: 'network',
              value: 'foobar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
      end
      describe 'check bad type' do
        context 'libvirt_uri' do
          before { params.merge!(libvirt_uri: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'virtio_net' do
          before { params.merge!(virtio_net: 'foobar') }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_mem' do
          before { params.merge!(default_mem: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_cpus' do
          before { params.merge!(default_cpus: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_bridge' do
          before { params.merge!(default_bridge: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_network' do
          before { params.merge!(default_network: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
      end
    end
  end
end
