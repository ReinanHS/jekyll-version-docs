require 'kramdown'
module Jekyll
  class PageWithoutAFile < Page
    def read_yaml(*)
      @data ||= {}
    end
  end
  class PageBuildDocs < Page
    def initialize(site, base, dir, filename, version)
      @site = site
      @base = base
      @dir  = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, "_docs/#{version}"), filename)

      self.content = Kramdown::Document.new(self.content).to_html
    end
  end
  class BuildDoc < Generator
    safe true
    priority :lowest

    # Main plugin action, called by Jekyll-core
    def generate(site)
      return Jekyll.logger.warn "\tJekyll Version Doc: The basic structure for the plugin's operation was not found" if !File.directory?("#{Dir.pwd}/_docs/")
     
      @site = site

      path = "#{Dir.pwd}/_docs/*"
      Dir[path].each do |filename|
        Jekyll.logger.info "\tSource: #{filename}"

        version = self.getFileVersion(filename)
        summaryFile = "#{filename}/Summary.md"
        summaryList = []

        if File.exists? summaryFile
          summaryList = self.extractInformation(summaryFile, version)
        else
          summaryList = self.extractInformationDir(filename, version)
        end

        filePath = "#{Dir.pwd}/_site/docs/#{version}"
        FileUtils.mkpath(filePath) unless File.exists?(filePath)


        summary_json = PageWithoutAFile.new(site, site.source, "/docs/#{version}", "summary.json")
        summary_json.content = summaryList.to_json
        site.pages << summary_json
        
        page = Jekyll::PageBuildDocs.new(site, site.source, "/docs/#{version}/", "#{summaryList[0].values[1]}.md", version)
        page.data["sitemap"] = false
        site.pages << page
      end
    end

    def extractInformation(filename, version)
      summaryList = []
      summary = File.read(filename).split('-')
      summary.each do |string|
        title = string[(string.index("[").to_i)+1..(string.index("]").to_i)-1]
        link = string[(string.index("(").to_i)+1..(string.index(")").to_i)-1]
        link.to_s.sub! '.md', ''
        link.to_s.sub! './', ''
        # Link without the need for JavaScript
        # link = self.getUrl("/docs/#{version}/#{link}")
        if !title.nil? 
          summaryList.push({ title: title, link: link })
        end
      end

      return summaryList
    end

    def extractInformationDir(dir, version)
      summaryList = []
      summary = Dir["#{dir}/*.md"]
      summary.each do |filename|
        filename = filename.split('/').last()
        title = filename.to_s.sub! '.md', ''
        link = filename
        # Link without the need for JavaScript
        # link = self.getUrl("/docs/#{version}/#{link}") 
        if !title.nil? && title != 'Summary.md'
          summaryList.push({ title: title, link: link })
        end
      end

      return summaryList
    end

    def getFileVersion(filename)
      version = filename.split('/')
      return version[(version.length-1)]
    end

    def getLastVersion
      path = "#{Dir.pwd}/_docs/*"
      return Dir[path].last().to_s.split("/").last()
    end

    def getUrl(input)
      return if input.nil?
      return Addressable::URI.parse(
        @site.config["url"].to_s + @site.config["baseurl"] + input
      ).normalize.to_s
    end
  end
end