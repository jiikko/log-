# f = File.open('./spec/files/sample.log').each_line.first
module Metscola::Parserable
  attr_reader :total_ms, :mss, :time, :method, :user_agent, :path
  attr_writer :total_ms, :mss

  def initialize(log)
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
