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

You can also download and install the module from puppet-forge via 
```puppet-module``` by running:

```shell
puppet-module install alup/rbenv
```

## Usage

You can use the module in your manifest with the following code:

```puppet
class { "rbenv":
  user    => "alup",
  compile => true,
  version => 1.9.3-p125,
}
```

This will apply an rbenv installation under "alup" user home dir
and will also compile ruby version 1.9.3-p125 to be ready for usage
(It will also set it as the global rbenv version for this user).

If you want only an rbenv installation without compiling any ruby
version, then just set ```compile``` parameter to ```false``` (It
defaults to ```true```).

All the variables except for the ```user```, are optional.

## Dry-run

If you want to just simulate (or smoke test) the installation of the
module, just clone the repository and use the following command:

```shell
sudo puppet apply --noop --modulepath=$PWD/../ tests/init.pp
```


## Testing

To run the tests, use ```bundle exec rake```. Before running the tests,
you should have run ```bundle install``` to ensure all the dependencies
have been met.


## Todo

Look at the TODO file.


## License

MIT License. Copyright 2012 Andreas Loupasakis.
