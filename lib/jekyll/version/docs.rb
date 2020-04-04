require "jekyll/version/docs/version"

module Jekyll
  module Version
    module Docs
      class Error < StandardError; end
      # Your code goes here...
    end
  end
end

require "jekyll/version/commands/vdoc"
require "jekyll/version/build/build-doc"