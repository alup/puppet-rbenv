class git::install {
  package {["git-core", "gitk"]:
      ensure   => 'present',
  }
}

class git {
  include git::install
}
