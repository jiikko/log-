require 'spec_helper'

describe Metscola::File do
  describe '#each_line' do
    it '時間で並び替えられていること' do
      logs = [
        '2016-12-03T19:25:45+09:00	',
        '2016-12-03T19:26:45+09:00	',
        '2016-12-03T12:27:45+09:00	',
        '2016-12-03T19:28:45+09:00	',
      ].join("\n")
      begin
        tempfile = Tempfile.new
        tempfile.write(logs) && tempfile.seek(0)
        expect(Metscola::File.new(tempfile).each_line(&:itself)).to eq([
        "2016-12-03T12:27:45+09:00	\n",
        "2016-12-03T19:25:45+09:00	\n",
        "2016-12-03T19:26:45+09:00	\n",
        "2016-12-03T19:28:45+09:00	",
        ])
      ensure
        tempfile.close
      end
    end
  end
end
