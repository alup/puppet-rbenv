class curl::install {
  package { "curl":
    ensure => "present"
  }
}

class curl {
  include curl::install
}
