class rbenv::dependencies {
  case $operatingsystem {
    Ubuntu,Debian: { require rbenv::dependencies::ubuntu }
    CentOS: { require rbenv::dependencies::centos }
  }
}
