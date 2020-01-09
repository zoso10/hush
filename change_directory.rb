# frozen_string_literal: true

module Hush
  class ChangeDirectory
    def self.call(directory = "~")
      substituted_directory = directory.gsub("~", ENV["HOME"])
      Dir.chdir(substituted_directory)
    end
  end
end
