# -*- frozen_string_literal: true -*-

require "metscola/version"
require 'metscola/parserable'
require 'metscola/worker'
require 'metscola/file'
require 'ruby-filemagic'
require 'fileutils'
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
      FileUtils.rm_rf(tmpdir_name)
      FileUtils.mkdir_p(tmpdir_name)

      if path.is_a?(String)
        worker = Metscola::Worker.new(path)
        worker.work!
        worker.to_filepath
      else
        Parallel.map(path, in_processes: Metscola::CONCURRENCY) do |path|
          worker = Metscola::Worker.new(path)
          worker.work!
          worker.to_filepath
        end
      end
    end

    def clean
      FileUtils.rm_rf(tmpdir_name)
      FileUtils.mkdir_p(tmpdir_name)
    end

    def tmpdir_name
      'metscola_tmp'
    end
  end

  SUMMARY_UNIT = 60 * 10 # 10分
  CONCURRENCY = 4
end
