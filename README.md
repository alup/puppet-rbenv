# Puppet-Rbenv

## About

This project provides manifests for the installation of
[rbenv](https://github.com/sstephenson/rbenv) (Ruby Version Management).


## Rbenv installation

You can use the module in your manifest with the following code:

```
rbenv::install { "someuser":
  group => 'project'
  home  => '/project'
}
```

This will apply an rbenv installation under "someuser" home dir
and place it into ".rbenv". You can change the resource title to
your taste, and pass the user on which install rbenv using the
`user` parameter.

The rbenv directory can be changed by passing the "root" parameter,
that must be an absolute path.

## Ruby compilation

To compile a ruby interpreter, you use `rbenv::compile` as follows:

```
rbenv::compile { "1.9.3-p370":
  user => "someuser",
  home => "/project",
}
```

The resource title is used as the ruby version, but if you have
multiple rubies under multiple users, you'll have to define them
explicitly:

```
rbenv::compile { "foo/1.8.7":
  user => "foo",
  ruby => "1.8.7-p370",
}

rbenv::compile { "bar/1.8.7":
  user => bar",
  ruby => "1.8.7-p370",
}
```

`rbenv rehash` is performed each time a new ruby or a new gem is
installed.

You can use the `default` parameter to set an interpreter as the
default one for the given user. Please note that only one default
is allowed, duplicate resources will be defined if you specify
multiple default ruby version.

## Gem installation

You can install and keep gems updated for a specific ruby interpreter:

```
rbenv::gem { "unicorn":
  user => "foobarbaz",
  ruby => "1.9.3-p370",
}
```

Gems are handled using a Package provider inherited from puppet's
`gem` one - so `absent` and `latest` work as expected.

## License

MIT License.

Copyright 2012 Andreas Loupasakis
Copyright 2012 Marcello Barnaba <vjt@openssl.it>
