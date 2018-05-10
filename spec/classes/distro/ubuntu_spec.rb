# frozen_string_literal: true

require 'spec_helper'

describe 'vmbuilder::distro::ubuntu' do
  let(:params) { {} }
  let(:ini_settings) do
    {
      'suite' => 'xenial',
      'flavour' => 'virtual',
      'components' => 'main, universe'
    }
  end

  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  # This will need to get moved
  # it { pp catalogue.resources }
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
              "/etc/vmbuilder.cfg [ubuntu] #{setting}"
            ).with(
              ensure: 'present',
              section: 'ubuntu',
              setting: setting,
              value: value,
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        %w[addpkg removepkg].each do |setting|
          it do
            is_expected.to contain_ini_setting(
              "/etc/vmbuilder.cfg [ubuntu] #{setting}"
            ).with(
              ensure: 'absent',
              section: 'ubuntu',
              setting: setting,
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
      end
      describe 'Change Defaults' do
        context 'default_suite' do
          before { params.merge!(default_suite: 'trusty') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [ubuntu] suite'
            ).with(
              ensure: 'present',
              section: 'ubuntu',
              setting: 'suite',
              value: 'trusty',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_flavour' do
          before { params.merge!(default_flavour: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [ubuntu] flavour'
            ).with(
              ensure: 'present',
              section: 'ubuntu',
              setting: 'flavour',
              value: 'foobar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_add_pkgs' do
          before { params.merge!(default_add_pkgs: %w[foo bar]) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [ubuntu] addpkg'
            ).with(
              ensure: 'present',
              section: 'ubuntu',
              setting: 'addpkg',
              value: 'foo, bar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_remove_pkgs' do
          before { params.merge!(default_remove_pkgs: %w[foo bar]) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [ubuntu] removepkg'
            ).with(
              ensure: 'present',
              section: 'ubuntu',
              setting: 'removepkg',
              value: 'foo, bar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
        context 'default_components' do
          before { params.merge!(default_components: %w[foo bar]) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_ini_setting(
              '/etc/vmbuilder.cfg [ubuntu] components'
            ).with(
              ensure: 'present',
              section: 'ubuntu',
              setting: 'components',
              value: 'foo, bar',
              path: '/etc/vmbuilder.cfg'
            )
          end
        end
      end
      describe 'check bad type' do
        context 'default_suite' do
          before { params.merge!(default_suite: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_flavour' do
          before { params.merge!(default_flavour: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_add_pkgs' do
          before { params.merge!(default_add_pkgs: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_remove_pkgs' do
          before { params.merge!(default_remove_pkgs: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'default_components' do
          before { params.merge!(default_components: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
      end
    end
  end
end
