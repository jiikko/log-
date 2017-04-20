# -*- frozen_string_literal: true -*-

module Metscola::Parserable
  attr_reader :total_ms, :mss, :time, :method, :user_agent, :path, :not_request
  attr_writer :total_ms, :mss
  attr_reader :log # for debug

  def initialize(log)
    @log = log # for debug
    log.scrub!('') =~ /in ([\d.]+)ms \(/
    @total_ms = $1.to_f
    /([\d:T-]+)\+09:00\t+([\w.]+)\t+({.*})/o =~ log
    json = JSON.parse($3)
    @time = Time.parse($1)
    messages = json['messages'].is_a?(Array) ? json['messages'].join : json['messages']
    @mss = messages.scan(/(\w+): ([\d.]+)ms/o).
      inject({}) { |a, v| a[v.first.to_sym] = v.last.to_f; a }
    @method = json['mt'] && json['mt'].to_sym
    @user_agent = json['ua']
    @path = json['pt']
    @not_request = true if @method.nil?
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
