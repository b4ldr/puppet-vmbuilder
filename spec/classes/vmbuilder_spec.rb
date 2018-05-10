require 'spec_helper'

describe 'vmbuilder' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  # include_context :hiera
  let(:node) { 'vmbuilder.example.com' }

  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  let(:facts) do
    {}
  end

  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  # This will need to get moved
  # it { pp catalogue.resources }
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      describe 'check default config' do
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file('/etc/vmbuilder.cfg').with(
            ensure: 'file',
          )
        end
      end
      describe 'Change Defaults' do
        context 'package' do
          before { params.merge!(package: 'foobar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'conf_file' do
          before { params.merge!(conf_file: '/foo/bar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'command' do
          before { params.merge!(command: '/foo/bar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_arch' do
          before { params.merge!(default_arch: 'foobar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_domain' do
          before { params.merge!(default_domain: 'foo.bar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_network' do
          before { params.merge!(default_network: '192.0.2.0') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_netmask' do
          before { params.merge!(default_netmask: '255.255.255.224') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_broadcast' do
          before { params.merge!(default_broadcast: '192.0.2.255') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_gateway' do
          before { params.merge!(default_gateway: '102.0.2.254') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_name' do
          before { params.merge!(default_name: 'foobar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_username' do
          before { params.merge!(default_username: 'foobar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_password' do
          before { params.merge!(default_password: 'foobar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_dns' do
          before { params.merge!(default_dns: '192.0.2.53') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_firstboot' do
          before { params.merge!(default_firstboot: '/foo/bar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_firstlogin' do
          before { params.merge!(default_firstlogin: '/foo/bar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_execscript' do
          before { params.merge!(default_execscript: '/foo/bar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
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
