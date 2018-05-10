require 'spec_helper'

describe 'vmbuilder::hypervisor::kvm' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  # include_context :hiera
  let(:node) { 'vmbuilder::hypervisor::kvm.example.com' }

  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  let(:facts) do
    {}
  end

  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      libvirt_uri: nil,
      virtio_net: nil,
      default_mem: nil,
      default_cpus: nil,
      default_bridge: nil,
      default_network: nil,

    }
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
      case facts[:operatingsystem]
      when 'Ubuntu'
        case facts['lsbdistcodename']
        when 'precise'
        else
        end
      else
      end
      describe 'check default config' do
        it { is_expected.to compile.with_all_deps }

      end
      describe 'Change Defaults' do
        context 'libvirt_uri' do
          before { params.merge!(libvirt_uri: 'XXXchangemeXXX') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'virtio_net' do
          before { params.merge!(virtio_net: 'XXXchangemeXXX') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_mem' do
          before { params.merge!(default_mem: 'XXXchangemeXXX') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_cpus' do
          before { params.merge!(default_cpus: 'XXXchangemeXXX') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_bridge' do
          before { params.merge!(default_bridge: 'XXXchangemeXXX') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_network' do
          before { params.merge!(default_network: 'XXXchangemeXXX') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
      end
      describe 'check bad type' do
        context 'libvirt_uri' do
          before { params.merge!(libvirt_uri: true) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'virtio_net' do
          before { params.merge!(virtio_net: true) }
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
