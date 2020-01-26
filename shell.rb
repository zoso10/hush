# frozen_string_literal: true

require "shellwords"

require_relative "alias"
require_relative "change_directory"
require_relative "directory_stack"
require_relative "echo"
require_relative "exec"
require_relative "exit"
require_relative "export"
require_relative "history"
require_relative "export"
require_relative "print_working_directory"
require_relative "whence"

require_relative "prompt"

module Hush
  class BangCommandError < StandardError; end

  class Shell
    def self.energy_recharge
      Hush.bedtime
    end

    # TODO: move this to it's own class. it's causing loading difficulties
    # as evident from above. moving this out of a constant we can start doing
    # runtime evaluation.
    BUILTINS = {
      "alias" => Hush::Alias,
      "cd" => Hush::ChangeDirectory,
      "echo" => Hush::Echo,
      "exec" => Hush::Exec,
      "exit" => Hush::Exit,
      "export" => Hush::Export,
      "history" => Hush::History,
      "pwd" => Hush::PrintWorkingDirectory,
      "popd" => Hush::DirectoryStack.method(:pop),
      "pushd" => Hush::DirectoryStack.method(:push),
      "dirs" => Hush::DirectoryStack.method(:list),
      "whence" => Hush::Whence,
      "where" => Hush::Whence.method(:where),
      "which" => Hush::Whence.method(:which),
      "bedtime" => self.method(:energy_recharge),
    }
    # this one is flawed but the one below this isnt perfect either
    # PIPE_SPLIT_REGEX = /([^"'|]+)|["']([^"']+)["']/.freeze
    PIPE_SPLIT_REGEX = /(.+(?<=\=)["'].+["'])|([^"'|]+)/.freeze

    def initialize
      @prompt = Hush::Prompt.new
    end

    def start!
      trap("SIGINT") do
        Hush.wake_up
        $stdout.puts
        prompt.print
      end

      loop do
        prompt.print
        line = $stdin.gets

        Hush::Exit.call if line.nil?

        Hush.work

        # this section should handle allll replacements:
        #   * bang commands
        #   * alias
        #   * command substitution
        # lol surprise! this can block on io
        replaced_line = replace_bang_commands(line.strip)

        commands = split_on_pipes(replaced_line)
        placeholder_in = $stdin
        placeholder_out = $stdout
        pipe = []

        commands.each_with_index do |command, index|
          # TODO: should be after the command has executed to be closer to spec
          Hush::History.add(command)

          # TODO: this needs to happen before splitting commands on pipes
          command = Hush::Alias.replace(command)

          program, *arguments = Shellwords.shellsplit(command)

          if builtin?(program)
            call_builtin(program, *arguments)
          else
            if index+1 < commands.size
              pipe = IO.pipe
              placeholder_out = pipe.last
            else
              placeholder_out = $stdout
            end

            pid = spawn_program(
              program,
              *arguments,
              placeholder_out,
              placeholder_in
            )

            # TODO: this doesn't work as expected
            # trap("SIGINT") { Process.kill("SIGINT", pid) }

            placeholder_out.close unless placeholder_out == $stdout
            placeholder_in.close unless placeholder_in == $stdin
            placeholder_in = pipe.first
          end
        end

        Process.waitall

      rescue Hush::BangCommandError
        $stdout.puts("hush: no such word in event")
      end
    end

    private

    attr_reader :prompt

    def replace_bang_commands(line)
      if line.match?(/!!/) || line.match?(/!\$/)
        if Hush::History.any?
          # only doing easy ones lol
          replaced = line.
            gsub("!!", Hush::History.last).
            gsub("!$", Hush::History.last.split.last)
          # lil jank
          prompt.print
          $stdout.print(replaced)
          replaced + $stdin.gets
        else
          raise Hush::BangCommandError
        end
      else
        line
      end
    end

    def split_on_pipes(line)
      line.scan(PIPE_SPLIT_REGEX).flatten.compact
    end

    def builtin?(program)
      BUILTINS.key?(program)
    end

    def call_builtin(program, *arguments)
      BUILTINS.fetch(program).call(*arguments)
    end

    def spawn_program(program, *arguments, placeholder_out, placeholder_in)
      fork do
        # TODO: learn how forking friggin processes works
        # trap(:SIGINT) { Hush::Exit.call(130) }

        unless placeholder_out == $stdout
          $stdout.reopen(placeholder_out)
          placeholder_out.close
        end

        unless placeholder_in == $stdin
          $stdin.reopen(placeholder_in)
          placeholder_in.close
        end

        exec program, *arguments
      rescue Errno::ENOENT
        $stdout.puts("hush: command not found: #{program}")
      end
    end
  end
end
