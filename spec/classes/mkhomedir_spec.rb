require 'spec_helper'

describe 'mkhomedir', :type => 'class' do

  context "Should create home base as directory" do
    let(:facts) {
     { :osfamily     => 'Debian' }
    }

    it do
      should contain_file('/nethome').with(
            'ensure'   => 'directory'
      )
    end
  end

  context "Should create home base as softlink" do

    let(:params) {
      { :home_basedir_link_target    =>  '/home' }
    }
    let(:facts) {
     { :osfamily     => 'Debian' }
    }

    it do
      should contain_file('/nethome').with(
            'ensure'   => 'link',
            'target'   => '/home'
      )
    end
  end

  context "On Debian type systems should create pam config file and exec pam_update_auth" do

    let(:params) {
      { :home_basedir_link_target    =>  '/home' }
    }

    let(:facts) {
     { :osfamily     => 'Debian' }
    }

    it do
      should contain_file('/nethome').with(
            'ensure'   => 'link',
            'target'   => '/home'
      )
      should contain_file('/usr/share/pam-configs/mkhomedir').with(
            'owner'   => 'root',
            'group'   => 'root'
      )
      should contain_exec('enable_mkhomedir')
    end
  end

  context "On RedHat type systems should create pam config file and exec pam_update_auth" do

    let(:params) {
      { :home_basedir_link_target    =>  '/home' }
    }

    let(:facts) {
     { :osfamily     => 'RedHat' }
    }

    it do
      should contain_file('/nethome').with(
            'ensure'   => 'link',
            'target'   => '/home'
      )
      should_not contain_file('/usr/share/pam-configs/mkhomedir')
      should contain_exec('enable_mkhomedir')
    end
  end

  context "Should fail with unsupported OS family" do

    let(:params) {
      { :home_basedir_link_target    =>  '/home' }
    }

    let(:facts) {
     { :osfamily     => 'Solaris' }
    }

    it do
      should raise_error(Puppet::Error, /mkhomedir - Unsupported Operating System family: Solaris at/)
    end
  end

end
