# frozen_string_literal: true

module Hush
  class PrintWorkingDirectory
    def self.call
      $stdout.puts Dir.pwd
    end
  end
end
