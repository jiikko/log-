# f = File.open('./spec/files/sample.log').each_line.first
module Metscola::Parserable
  attr_reader :total_ms, :mss, :time, :method, :user_agent, :path
  attr_writer :total_ms, :mss

  def initialize(log)
    log =~ /in ([\d.]+)ms \(/
    @total_ms = $1.to_f
    /([\d:T-]+)\+09:00\t+([\w.]+)\t+({.*})/o =~ log
    json = JSON.parse($3)
    @time = Time.parse($1)
    @mss = json['messages'].scan(/(\w+): ([\d.]+)ms/o).map { |name, ms| [name, ms.to_f] }
    @method = json['mt'].to_sym
    @user_agent = json['ua']
    @path = json['pt']
  end

  def formated_time
    time.strftime('%Y/%m/%d %H:%M')
  end

  def user_agent_type
    if @user_agent =~ /iPhone|Android|Mobile|Windows Phone/o
      :sp
    else
      :pc
    end
  end

  def hash
    [path, method].hash
  end
end
