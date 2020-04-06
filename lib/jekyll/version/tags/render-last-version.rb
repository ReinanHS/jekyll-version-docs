module Jekyll
  class RenderLastVersion < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      path = "#{Dir.pwd}/_docs/*"
      @lastVersion = Dir[path].last().to_s.split("/").last()
    end

    def render(context)
      "#{@lastVersion}"
    end
  end

  class RenderVersions < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      path = "#{Dir.pwd}/_docs/*"
      @versions = Dir[path]
    end

    def render(context)
      list = ''
      @versions.each do |filename|
        version = filename.to_s.split("/").last()
        list = list + '<a class="dropdown-item" href="'+"./#{version}"+'">'+"#{version}"+'</a>'
      end

      return list
    end
  end
end

Liquid::Template.register_tag('doc_version', Jekyll::RenderLastVersion)
Liquid::Template.register_tag('doc_versions', Jekyll::RenderVersions)