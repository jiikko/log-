require "metscola/version"
require 'metscola/parser'
require 'metscola/runner'
require 'metscola/worker'
require 'thread'
require 'json'

module Metscola
  class << self
    attr_writer :summary_range

    def summary_range
      @summary_range || SUMMARY_RANGE
    end
  end

  SUMMARY_RANGE = 60
end
