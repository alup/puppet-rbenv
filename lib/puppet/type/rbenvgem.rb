Puppet::Type.newtype(:rbenvgem) do
  desc 'A Ruby Gem installed inside an rbenv-installed Ruby'

  ensurable do
    newvalue(:present) { provider.install   }
    newvalue(:absent ) { provider.uninstall }

    newvalue(:latest) {
      provider.uninstall if provider.current
      provider.install
    }

    newvalue(/./)  do
      provider.uninstall if provider.current
      provider.install
    end

    aliasvalue :installed, :present

    defaultto :present

    def retrieve
      provider.current || :absent
    end

    def insync?(current)
      requested = @should.first

      case requested
      when :present, :installed
        current != :absent
      when :latest
        current == provider.latest
      when :absent
        current == :absent
      else
        current == [requested]
      end
    end
  end

  newparam(:name) do
    desc 'Gem qualified name within an rbenv repository'
  end

  newparam(:gemname) do
    desc 'The Gem name'
  end

  newparam(:ruby) do
    desc 'The ruby interpreter version'
  end

  newparam(:rbenv) do
    desc 'The rbenv root'
  end

  newparam(:user) do
    desc 'The rbenv owner'
  end

  newparam(:source) do
    desc 'The gem source'
  end

  newparam(:timeout) do
    desc "Maximum time permitted for `gem` to execute.
      Defaults to 300 seconds."

    munge do |value|
      value = value.shift if value.is_a?(Array)
      begin
        value = Float(value)
      rescue ArgumentError
        raise ArgumentError, "The timeout must be a number.", $!.backtrace
      end
      [value, 0.0].max
    end

    defaultto 300
  end

end
