class rbenv::dependencies {
  case $operatingsystem {
    Ubuntu,Debian: { require rbenv::dependencies::ubuntu }
    RedHat,CentOS: { require rbenv::dependencies::centos }
  }
}
