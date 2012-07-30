require 'puppet/provider/package/gem'

# This provider extends the original Gem one, and hacks the "gemcmd" command
# by adding the prefix passed to the resource into the "root" parameter.
#
Puppet::Type.type(:package).provide :rbenvgem, :parent => :gem do
  desc "Maintains gems inside an RBenv setup"

  commands :gemcmd => 'gem'

  # This provider should never be called by default.
  def self.specificity
    -0xff
  end

  def gemcmd(*args)
    args.shift
    args.unshift(scoped_gem)

    super(*args)
  end

  def command(*args)
    return super unless args.first == :gemcmd
    scoped_gem
  end

  def execute(command)
    if command.last =~ / :: /
      gem = command.pop
      command.push gem.split(' :: ').last
    end

    super
  end

  private
    def scoped_gem
      resource[:root] + '/bin/gem'
    end
end
