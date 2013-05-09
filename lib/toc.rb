class TOC
  def initialize(lang)
    @lang = lang
    file = "#{File.dirname(__FILE__)}/toc.#{lang}.rb"
    eval(File.read(file), binding, file)
  end

  def sections
    @sections ||= []
  end

  # define a section
  def section(name, title)
    sections << [name, title, []]
    yield if block_given?
  end

  # define a category
  def category(name, title)
    sections.last.last << [name, title, []]
    yield if block_given?
  end

  # define a article
  def article(name, title, keywords=[])
    path = "#{File.dirname(__FILE__)}/../docs/#{@lang}/#{name}.txt"
    if FileTest.exists? path
      open(path) do |file|
        while line = file.gets
          if line =~ /^(?:\s*#+\s+)(.*)(?:\s*)$/
            title = $1
            break
          end
        end
      end
    end

    keywords = [name] + keywords
    sections.last.last.last.last << [name, title, keywords]
  end
end
