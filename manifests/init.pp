# Class: rbenv
#
# This module manages puppet-rbenv
#
# Parameters:
# - *user*: the user who is going to install rbenv. defaults to $USER
# - *global_ruby*: the global ruby version which is going to be compiled and
#   installed. It is optional as it is used by the 
#
# Actions:
#
# Requires:
# - git and curl
#
# Sample Usage:
#
#     $user = "alup"
#     include rbenv
#     rbenv::compile {
#       global_ruby => "1.9.2-p290"
#     }
#
# [Remember: No empty lines between comments and class definition]
class rbenv {

  # Include dependencies
  include git, curl

  include rbenv::install
}
