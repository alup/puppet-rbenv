Puppet::Type.type(:rbenvgem).provide :default do
  desc "Maintains gems inside an RBenv setup"

  def install
    args = ['install', '--no-rdoc', '--no-ri']
    args << "-v#{resource[:ensure]}" if !resource[:ensure].kind_of?(Symbol)
    args << [ '--source', "'#{resource[:source]}'" ] if resource[:source] != ''
    args << gem_name
    output = gem(*args)
    fail "Could not install: #{output.chomp}" if output.include?('ERROR')
  end

  def uninstall
    gem 'uninstall', '-aIx', gem_name
  end

  def latest
    @latest ||= list(:remote)
  end

  def current
    list
  end

  private
    def gem_name
      resource[:gemname]
    end

    def gem(*args)
      require 'etc'
      user = resource[:user]
      home = Etc.getpwnam(user)[:dir]

      exe  = "#{resource[:rbenv]}/bin/gem"

      Puppet::Util::Execution.execute([exe, *args].join(' '),
        :uid => user,
        :failonfail => true,
        :custom_environment => {
          'HOME'          => home,
          'RBENV_VERSION' => resource[:ruby],
        }
      )
    end

    def list(where = :local)
      args = ['list', where == :remote ? '--remote' : '--local', "#{gem_name}$"]

      gem(*args).lines.map do |line|
        line =~ /^(?:\S+)\s+\((.+)\)/

        return nil unless $1

        # Fetch the version number
        ver = $1.split(/,\s*/)
        ver.empty? ? nil : ver
      end.first
    end
end
