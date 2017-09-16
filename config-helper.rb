class ConfigHelper
  def initialize(config, env = {})
    @config = config
    @env = env
  end

  def provision(*params)
    config.vm.provision *params
  end

  def file(**kw)
    provision :file, **kw
  end

  def shell(**kw)
    provision :shell, **kw, env: env
  end

  def inline(cmd, **kw)
    shell inline: cmd, **kw
  end

  def script(path, **kw)
    shell path: path, **kw
  end

  def step(name, **kw)
    shell name: name, path: "provision/#{name}.sh", **kw
  end

  def copy_file(**kw)
    source = kw[:source]
    destination = kw[:destination]
    source_basename = File.basename(source)
    if destination[-1] == "/"
      dest_dir = destination
      dest_file = File.join(dest_dir, source_basename)
    else
      dest_dir = File.dirname(destination)
      dest_file = destination
    end
    tmp_dest = Dir::Tmpname.make_tmpname ["/tmp/", source_basename], nil
    file source: source, destination: tmp_dest
    inline "mv #{tmp_dest} #{dest_file}"
  end

  def env
    @env
  end

  def config
    @config
  end

  def truncate(path, **kw)
    inline "> #{path}", **kw
  end

  def append(path, text, **kw)
    inline "echo \"#{text}\" >> #{path}", **kw
  end

  class NewFile
    def initialize(helper, path)
      @helper = helper
      @path = path
    end
    def append(text, **kw)
      @helper.append @path, text, **kw
    end
  end

  def new_file(path, **kw, &block)
    inline "> #{path}", **kw
    if block_given?
      block.call(NewFile.new(self, path))
    end
  end
end
