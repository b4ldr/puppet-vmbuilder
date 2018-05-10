require 'spec_helper'

describe 'vmbuilder::distro::ubuntu' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  # include_context :hiera
  let(:node) { 'vmbuilder::distro::ubuntu.example.com' }

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
      default_suite: nil,
      default_flavour: nil,
      default_add_pkgs: nil,
      default_remove_pkgs: nil,
      default_components: nil,

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
        context 'default_suite' do
          before { params.merge!(default_suite: 'XXXchangemeXXX') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_flavour' do
          before { params.merge!(default_flavour: 'XXXchangemeXXX') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_add_pkgs' do
          before { params.merge!(default_add_pkgs: 'XXXchangemeXXX') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_remove_pkgs' do
          before { params.merge!(default_remove_pkgs: 'XXXchangemeXXX') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
        end
        context 'default_components' do
          before { params.merge!(default_components: 'XXXchangemeXXX') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
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
