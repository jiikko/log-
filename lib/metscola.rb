require "metscola/version"
require 'metscola/parserable'
require 'metscola/runner'
require 'metscola/worker'
require 'thread'
require 'json'
require 'parallel'

module Metscola
  class << self
    attr_writer :summary_range

    def summary_range
      @summary_range || SUMMARY_UNIT
    end

    def new(path)
      Metscola::Runner.new(path)
    end
  end

  SUMMARY_UNIT = 60 * 10 # 10分
  CONCURRENCY = 4
end
