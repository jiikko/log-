class Metscola::Worker
  class Request; end
  Request.class_eval do
    if Metscola.target
      include Metscola.target
    else
      raise 'not defined parser'
    end
  end

  class Summary
    class RequestList
      def initialize
        @map = {}
      end

      def <<(new_request)
        old_request = @map[new_request.hash]
        if old_request
          @map[new_request.hash] = old_request.merge(new_request)
        else
          @map[new_request.hash] = new_request
        end
      end

      def list
        @map.values
      end

      def each(&block)
        list.each do |item|
          yield(item)
        end
      end
    end

    class Request
      include Metscola::BaseParserable

      def initialize(log)
        super
        @merged_count = 0
      end

      def merge(new_request)
        @merged_count = @merged_count + 1
        new_request.mss.each do |key, value|
          self.mss[key] = (value + self.mss[key]) / 2
        end
        self.total_ms = (self.total_ms + new_request.total_ms) / 2
        self
      end

      def to_json
        { total_ms: total_ms,
          mss: mss,
          time: time,
          method: method,
          user_agent: user_agent_type,
          path: path,
          merged_count: @merged_count
        }.to_json
      end
    end

    def initialize
      @map = {}
      @current_time = nil
      @pc_list = []
      @sp_list = []
    end

    def add(request)
      @current_time ||= request.time
      if (@current_time..(@current_time + Metscola.summary_range)).include?(request.time)
        # nothing
      else
        permanent_list!
        @current_time = request.time
      end

      if @map[current_time_to_s].nil?
        @map[current_time_to_s] = {}
        @map[current_time_to_s][:pc] = RequestList.new
        @map[current_time_to_s][:sp] = RequestList.new
      end
      @map[current_time_to_s][request.user_agent_type] << request
    end

    def list(device)
      case device
      when :pc
        @pc_list
      when :sp
        @sp_list
      end
    end

    # 最後に取り込んだログを吐き出す
    def flush!
      permanent_list!
    end

    private

    def permanent_list!
      @map[current_time_to_s][:pc].each do |request|
        @pc_list << request
      end
      @map[current_time_to_s][:sp].each do |request|
        @sp_list << request
      end
      @map[current_time_to_s] = nil # 不要なので
    end

    def current_time_to_s
      @current_time.strftime('%Y/%m/%d %H:%M')
    end
  end

  def initialize(path)
    @path = path
    @summary = Summary.new
  end

  def work!
    File.open(@path).each_line do |line|
      request = Metscola::Worker::Summary::Request.new(line)
      @summary.add(request)
    end
    @summary.flush!
  end

  def summary
    @summary
  end

  def list(device = nil)
    case device
    when :pc, :sp
      summary.list(device)
    when nil
      summary.list(:pc).concat(summary.list(:sp))
    end
  end

  def to_tempfile
    tempfile = Tempfile.new
    tempfile.write(list.map(&:to_json).join("\n"))
    tempfile
  end
end
