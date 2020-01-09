# frozen_string_literal: true

require_relative "shell"

module Hush
  class Whence
    def self.call(*arguments)
      options, names = arguments.partition { |arg| arg.start_with?("-") }

      names.each do |name|
        locations = []
        builtin = if options.any? { |opt| opt =~ /c/ }
                    "#{name}: shell built-in command"
                  else
                    name
                  end
        locations << builtin if Hush::Shell::BUILTINS.key?(name)
        ENV["PATH"].split(":").each do |dir|
          locations << File.join(dir, name) if Dir.entries(dir).include?(name)
        rescue Errno::ENOENT
        end

        next if locations.empty?

        if options.any? { |opt| opt =~ /a/ }
          $stdout.puts(locations)
        else
          $stdout.puts(locations.first)
        end
      end
    end

    def self.where(*arguments)
      call("-ca", *arguments)
    end

    def self.which(*arguments)
      call("-c", *arguments)
    end
  end
end
