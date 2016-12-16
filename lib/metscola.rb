require "metscola/version"
require 'metscola/parserable'
require 'metscola/runner'
require 'metscola/worker'
require 'thread'
require 'json'
require 'parallel'



module Metscola
  class << self
    attr_writer :summary_range, :target, :parers

    def summary_range
      @summary_range || SUMMARY_UNIT
    end

    def new(path, target: nil)
      Metscola::Runner.new(path)
    end

  end

  def target=(value)
    self.class.target = Metscola::Parser.build_module(value)
  end

  SUMMARY_UNIT = 60 * 10 # 10分
  CONCURRENCY = 4
end


module Metscola::Parser
  def initialize
    @parsers[value[:name]] = {
      attrs: value[:attrs]

    }
  end
end
