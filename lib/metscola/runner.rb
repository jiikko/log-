class Metscola::Runner
  def initialize
  end

  def send_events
    result = []
    File.open('/Users/koji/metscola/spec/files/sample.log').each_line do |log|
      result << parser.to_hash
    end
    result
  end
end
