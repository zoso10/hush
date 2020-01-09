# frozen_string_literal: true

require_relative "shell"

module Hush
  def self.shell
    @_shell ||= Hush::Shell.new
  end
end
