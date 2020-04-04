require 'fileutils'

module Jekyll
  module Commands
    class VDoc < Command
      class << self
        def init_with_program(prog)
          prog.command(:vdoc) do |c|

            c.syntax "vdoc VERSION"
            c.description "Create a new version for the documentation"

            c.action do |args, options|
              if args.length != 1
                Jekyll.logger.error "You entered the command with invalid parameters, See example: jekyll vdoc 1.0"
              else
                lastVersion = self.getLestVersion.to_s.split("/").last()
                newVersion = args[0] ? args[0] : '0.0.1'
                if !self.checkIncompatibility(lastVersion, newVersion)
                  self.createVersion(newVersion)
                  Jekyll.logger.info "Version #{newVersion} was successfully created"
                end
              end
            end
          end
        end

        def getLestVersion

          path = "#{Dir.pwd}/_docs"

          if !File.directory?(path)
            Dir.mkdir(path) unless Dir.exist?(path)            
          end

          return Dir["#{path}/*"].last()
        end

        def createVersion(newVersion)
          lastVersion_dir = Dir["#{self.getLestVersion}/*.md"]
          path = "#{Dir.pwd}/_docs/#{newVersion.to_s}"

          if !File.directory?(path)
            Dir.mkdir(path) unless Dir.exist?(path)            
          end

          lastVersion_dir.each do |filename|
            name = File.basename('filename', '.md')[0,4]
            dest_folder = "#{path}/"
            FileUtils.cp(filename, dest_folder)
          end
        end

        def checkIncompatibility(lastVersion, newVersion)
          path = "#{Dir.pwd}/_docs"

          raise ArgumentError.new("A version already exists at #{path}/#{newVersion}") if(lastVersion == newVersion)

          versions = Dir["#{path}/*"]
          result = versions.find {|item| item == "#{path}/#{newVersion}" }
          
          raise ArgumentError.new("A version already exists at #{path}/#{newVersion}") if(result)

          return false
        end
      end
    end
  end
end