require 'spec_helper'

describe Metscola::Worker do
  it '集計すること' do
    Metscola.summary_range = 1
    worker = Metscola::Worker.new('./files/sample.log', 0)
    worker.work!
  end
end
