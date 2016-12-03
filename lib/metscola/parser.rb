# f = File.open('./spec/files/sample.log').each_line.first
class Metscola::Parser
  attr_accessor :total_ms, :mss, :time, :method, :user_agent, :path

  def initialize(log)
    log =~ /in (\d.)+ms \(/
    total_ms = $1
    /([\d:T-]+)\+09:00\t+([\w.]+)\t+({.*})/ =~ log
    json = JSON.parse($3)
    @time = Time.parse($1)
    @mss = json['messages'].scan(/(\w+): ([\d.]+)ms/)
    @total_ms = total_ms
    @method = json['mt']
    @user_agent = json['ua']
    @path = json['pt']
  end
end
