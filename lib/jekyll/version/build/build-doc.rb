module Jekyll
  class PageWithoutAFile < Page
    def read_yaml(*)
      @data ||= {}
    end
  end
  class BuildDoc < Jekyll::Generator
    safe true
    priority :highest

    # Main plugin action, called by Jekyll-core
    def generate(site)
      return Jekyll.logger.warn "\tJekyll Version Doc: The basic structure for the plugin's operation was not found" if !File.directory?("#{Dir.pwd}/_docs/")
      
      path = "#{Dir.pwd}/_docs/*/Summary.md"
      Dir[path].each do |filename|
        Jekyll.logger.info "\tSource: #{filename}"

        version = self.getFileVersion(filename)
        summaryList = self.extractInformation(filename)

        filePath = "#{Dir.pwd}/_site/docs/#{version}"
        FileUtils.mkpath(filePath) unless File.exists?(filePath)


        summary_json = PageWithoutAFile.new(site, site.source, "/docs/#{version}", "summary.json")
        summary_json.content = summaryList.to_json
        site.pages << summary_json
      end
    end

    def extractInformation(filename)
      summaryList = []
      summary = File.read(filename).split('-')
      summary.each do |string|
        title = string[(string.index("[").to_i)+1..(string.index("]").to_i)-1]
        link = string[(string.index("(").to_i)+1..(string.index(")").to_i)-1]
        link.to_s.sub! '.md', '.html'
        if !title.nil? 
          summaryList.push({ title: title, link: link })
        end
      end

      return summaryList
    end

    def getFileVersion(filename)
      version = filename.split('/')
      return version[(version.length-2)]
    end
  end
end