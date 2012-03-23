class git::install {
  package {"git-core":
      ensure   => 'present',
  }
}

class git {
  include git::install
}
