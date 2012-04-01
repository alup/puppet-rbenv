# Puppet-Rbenv

[![Build Status](https://secure.travis-ci.org/alup/puppet-rbenv.png?branch=master)](http://travis-ci.org/alup/puppet-rbenv)

## About

This project provides manifests for the installation of
[rbenv](https://github.com/sstephenson/rbenv) (Ruby Version Management).


## Install

1. Install dependencies (Rubygems and Puppet):

        sudo apt-get install rubygems puppet # Ubuntu/Debian

2. Apply the catalog of chosen modules(serverless install):

        puppet apply ...


## Dry-run

If you want to just simulate the installation of the module, just 
clone the repository and use the following command:

```shell
sudo puppet apply --noop --modulepath=$PWD/../ tests/init.pp
```


## Todo

Look at the TODO file.


## License

MIT License. Copyright 2012 Andreas Loupasakis.
