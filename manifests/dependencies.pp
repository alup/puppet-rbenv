class rbenv::dependencies {
  case $::osfamily {
    debian : { require rbenv::dependencies::ubuntu }
    redhat : { require rbenv::dependencies::centos }
    suse   : { require rbenv::dependencies::suse   }
  }
}
