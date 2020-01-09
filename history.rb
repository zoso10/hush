# frozen_string_literal: true

module Hush
  class History
    @commands = []

    class << self
      def call(*)
        output = commands.
          take(16).
          map.
          with_index { |c, idx| idx.to_s.rjust(5) + "  #{c}" }
        $stdout.puts(output)
      end

      def add(command)
        command = command.strip
        commands.push(command) unless commands.last == command
        hist_size = ENV["HISTSIZE"] || 200
        commands.shift if commands.length > hist_size.to_i
      end

      def last
        commands.last
      end

      def any?
        commands.any?
      end

      private

      attr_accessor :commands
    end
  end
end
