# frozen_string_literal: true

module Hush
  class Exit
    SUCCESS = 0

    def self.call(code = SUCCESS)
      exit(code.to_i)
    end
  end
end
