# frozen_string_literal: true

module Hush
  class Alias
    def self.call(*arguments)
      require "pry-byebug"
      binding.pry
      $stdout.puts("yey")
    end
  end
end
