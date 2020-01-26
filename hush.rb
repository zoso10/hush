# frozen_string_literal: true

require_relative "energy"
require_relative "shell"

module Hush
  def self.shell
    @_shell ||= Hush::Shell.new
  end

  def self.work
    energy.expend
  end

  def self.bedtime
    energy.recharge
  end

  def self.wake_up
    energy.discharge
  end

  def self.energy
    @_energy ||= Hush::Energy.new
  end
  private_class_method :energy
end
