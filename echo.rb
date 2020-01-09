# frozen_string_literal: true

module Hush
  class Echo
    def self.call(string = "")
      $stdout.puts string
    end
  end
end
