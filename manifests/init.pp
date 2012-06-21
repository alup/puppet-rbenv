# Class: rbenv
#
# This module manages puppet-rbenv
#
# Parameters:
# - *user*: the user who is going to install rbenv. defaults to $USER
# - *compile*: whether or not a ruby version will be compiled
# - *version*: the global ruby version which is going to be compiled and
#   installed. It is optional.
#
# Actions:
#
# Requires:
# - git and curl
# - Some packages for compiling native extensions
#
# Sample Usage:
#
#     class { "rbenv":
#         user     => "alup",
#         home_dir => "/project/alup",
#         compile  => true,
#         version  => "1.9.3-p0",
#     }
#
# [Remember: No empty lines between comments and class definition]
class rbenv ( $user, $home_dir="/home/${user}", $compile=true, $version='1.9.3-p194' ) {

  include rbenv::dependencies

  rbenv::install { "rbenv::install::${user}":
    user      => $user,
    home_dir  => $home_dir,
  }

  if $compile {
    rbenv::compile { "rbenv::compile::${user}::${version}":
      user         => $user,
      home_dir     => $home_dir,
      ruby_version => $version,
    }
  }

}
