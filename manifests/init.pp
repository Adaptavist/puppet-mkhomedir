class mkhomedir (
    $authconfig_command        = 'authconfig --enablemkhomedir --update',
    $authconfig_package        = 'authconfig',
    $pam_auth_update           = 'pam-auth-update',
    $pam_mkhomedir_file        = '/usr/share/pam-configs/mkhomedir',
    $umask                     = '0022',
    $skel                      = '/etc/skel',
    $home_basedir              = '/nethome',
    $home_basedir_link_target  = undef,

    )  {

    # Make sure the home base directory exists

    # If there is a link target make the basedir a softlink
    if ($home_basedir_link_target) {
        file { $home_basedir:
            ensure => 'link',
            target => $home_basedir_link_target
        }
    }
    # if not make sure its a directory
    else {
        file { $home_basedir:
            ensure => 'directory'
        }
    }

    # Enable pam_mkhomedir
    case $::osfamily {
        Debian: {
            #create pam config file
            file { $pam_mkhomedir_file:
                content => template("${name}/mkhomedir.erb"),
                owner   => 'root',
                group   => 'root'
            }
            #enable the pam_mkhomedir module
            exec { 'enable_mkhomedir':
                command => $pam_auth_update,
                path    => '/usr/bin:/usr/sbin:/bin:/sbin',
                require => File[$pam_mkhomedir_file]
            }
        }
        RedHat: {
            #enable the pam_mkhomedir module
            if (!defined(Package[$authconfig_package])) {
                package { $authconfig_package:
                    ensure => installed
                }
            }
            exec { 'enable_mkhomedir':
                command => $authconfig_command,
                path    => '/usr/bin:/usr/sbin:/bin:/sbin',
                require => Package[$authconfig_package],
            }
        }
        default: {
            fail("mkhomedir - Unsupported Operating System family: ${::osfamily}")
        }
    }

}