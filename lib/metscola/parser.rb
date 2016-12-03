# f = File.open('./spec/files/sample.log').each_line.first
class Metscola::Parser
  def initialize(log)
    /([\d:T-]+)\+09:00\t+([\w.]+)\t+({.*})/ =~ log
    json = JSON.parse($3)
    @event = $2.dup
    @hash = {
      time: Time.parse($1).to_i,
      method: json['mt'] || 'bbba',
      user_agent: json['ua'] || 'hhhh',
      path: json['pt'] || 'bbba',
    }
  end

  def event
    @event
  end

  def to_hash
    @hash
  end
end
