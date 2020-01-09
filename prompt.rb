# frozen_string_literal: true

module Hush
  class Prompt
    def initialize
      ENV["PROMPT"] ||= "-> "
    end

    def print
      $stdout.print(ENV["PROMPT"])
    end
  end
end
