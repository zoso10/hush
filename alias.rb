# frozen_string_literal: true

module Hush
  class Alias
    @map = {}

    class << self
      def call(*arguments)
        original_command, alias_command = arguments.first.split("=")
        map[original_command] = alias_command
      end

      def replace(command)
        command.yield_self do |cmd|
          map.each do |orig, ali|
            cmd = cmd.gsub(orig, ali)
          end
          cmd
        end
      end

      private

      attr_accessor :map
    end
  end
end
