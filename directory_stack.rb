# frozen_string_literal: true

require_relative "change_directory"

module Hush
  class DirectoryStack
    EMPTY_STACK_MESSAGE = "popd: directory stack empty"

    @stack = []

    class << self
      def push(directory)
        stack.unshift(Dir.pwd)
        Hush::ChangeDirectory.call(directory)
        list
      end

      def pop
        if stack.empty?
          $stdout.puts EMPTY_STACK_MESSAGE
        else
          Hush::ChangeDirectory.call(stack.shift)
          list
        end
      end

      def list
        current_plus_stack = [Dir.pwd] + stack
        $stdout.puts(current_plus_stack.join(" "))
      end

      private

      attr_accessor :stack
    end
  end
end
