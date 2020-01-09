# frozen_string_literal: true

module Hush
  class Export
    def self.call(args)
      key, value = args.split("=").map(&:strip)
      ENV[key] = value
    end
  end
end
