require 'kramdown'
module Jekyll
  class PageWithoutAFile < Page
    def read_yaml(*)
      @data ||= {}
    end
  end
  class PageBuildDocs < Page
    # def initialize(site, base, dir, name, content)
    #   @site = site
    #   @base = base
    #   @dir  = dir
    #   @name = name

    #   self.data = {
    #     "layout" => 'docs.html'
    #   }
    #   self.content = content

    #   process(name)
    #   # read_yaml(PathManager.join(base, '_layouts'), 'docs.html')
    # end
    def initialize(site, base, dir, filename)
      @site = site
      @base = base
      @dir  = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_docs/1.0'), filename)

      self.content = Kramdown::Document.new(self.content).to_html
    end
  end
  class BuildDoc < Generator
    safe true
    priority :lowest

    # Main plugin action, called by Jekyll-core
    def generate(site)
      return Jekyll.logger.warn "\tJekyll Version Doc: The basic structure for the plugin's operation was not found" if !File.directory?("#{Dir.pwd}/_docs/")
     
      path = "#{Dir.pwd}/_docs/*"
      Dir[path].each do |filename|
        Jekyll.logger.info "\tSource: #{filename}"

        version = self.getFileVersion(filename)
        summaryFile = "#{filename}/Summary.md"
        summaryList = []

        if File.exists? summaryFile
          summaryList = self.extractInformation(summaryFile)
        else
          summaryList = self.extractInformationDir(filename)
        end

        filePath = "#{Dir.pwd}/_site/docs/#{version}"
        FileUtils.mkpath(filePath) unless File.exists?(filePath)


        summary_json = PageWithoutAFile.new(site, site.source, "/docs/#{version}", "summary.json")
        summary_json.content = summaryList.to_json
        site.pages << summary_json

        if !File.file? "#{filePath}/index.html"
          page = Jekyll::PageBuildDocs.new(site, site.source, "/docs/#{version}/", 'Introduction.md')
          page.data["sitemap"] = false
          site.pages << page
        end
      end
    end

    def extractInformation(filename)
      summaryList = []
      summary = File.read(filename).split('-')
      summary.each do |string|
        title = string[(string.index("[").to_i)+1..(string.index("]").to_i)-1]
        link = string[(string.index("(").to_i)+1..(string.index(")").to_i)-1]
        link.to_s.sub! '.md', '/'
        if !title.nil? 
          summaryList.push({ title: title, link: link })
        end
      end

      return summaryList
    end

    def extractInformationDir(dir)
      summaryList = []
      summary = Dir["#{dir}/*.md"]
      summary.each do |filename|
        filename = filename.split('/').last()
        title = filename.to_s.sub! '.md', ''
        link = "#{filename}/"
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

  end
end