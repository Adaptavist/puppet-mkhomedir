# mkhomedir Module

## Overview

The **mkhomedir** module enables the pam mkdirhome module, it also ensures the homedir base exists and is either a directory or a softlink

##Configuration

###`authconfig_command`

The PAM update command to run on RedHat based systems **Default:  'authconfig --enablemkhomedir --update'**

###`pam_auth_update`

The PAM update command to run on Debian based systems **Default: 'pam-auth-update'**

###`pam_mkhomedir_file`

The location of the PAM config file for mkhomedir to use on Debian based systems **Default:  '/usr/share/pam-configs/mkhomedir'**

###`umask` 

The umask for directories **Default: 0022'**

###`skel`

The location of the skel template directory **Default: '/etc/skel'**

###`home_basedir` 

The base directory for home directories, if ***home_basedir_link_target*** is set than this will be a softlink, if not it'll be a directory **Default: '/nethome'**

###`home_basedir_link_target`

A soft link target for the home diretory base location **Default: undef**

##Hiera Examples:

* Global Settings

        #link /nethome to /home
        mkhomedir::home_basedir: '/nethome'
        mkhomedir::home_basedir_link_target::  '/home'
        
## Dependencies

This module has no dependencies