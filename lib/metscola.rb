require "metscola/version"
require 'metscola/parserable'
require 'metscola/worker'
require 'metscola/file'
require 'ruby-filemagic'
require 'json'
require 'time'
require 'parallel'

module Metscola
  class << self
    attr_writer :summary_range

    def summary_range
      @summary_range || SUMMARY_UNIT
    end

    def run(path)
      if path.is_a?(String)
        worker = Metscola::Worker.new(path)
        worker.work!
        worker.to_tempfile
      else
        Parallel.map(path, in_processes: Metscola::CONCURRENCY) do |path|
          worker = Metscola::Worker.new(path)
          worker.work!
          worker.to_tempfile
        end
      end
    end
  end

  SUMMARY_UNIT = 60 * 10 # 10分
  CONCURRENCY = 4
end
