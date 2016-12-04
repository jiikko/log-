class Metscola::Worker
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
      def initialize(parser)
        @parser = parser
        @merged_count = 0
      end

      def hash
        [@parser.path, @parser.method].hash
      end

      def merge(new_request)
        @merged_count = @merged_count + 1
        # @mss
        self.total_ms = (self.total_ms + new_request.total_ms) / 2
        self
      end

      def total_ms
        @parser.total_ms
      end

      def total_ms=(value)
        @parser.total_ms = value
      end
    end

    def initialize
      @map = {}
      @current_time = nil
      @pc_list = []
      @sp_list = []
    end

    def add(parser)
      @current_time ||= parser.time
      if (@current_time..(@current_time + Metscola.summary_range)).include?(parser.time)
        # nothing
      else
        permanent_list!
        @current_time = parser.time
      end

      if @map[current_time_to_s].nil?
        @map[current_time_to_s] = {}
        @map[current_time_to_s][:pc] = RequestList.new
        @map[current_time_to_s][:sp] = RequestList.new
      end
      @map[current_time_to_s][parser.user_agent_type] << Request.new(parser)
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

  def initialize(path, position)
    @path = path
    @position = position
    @summary = Summary.new
  end

  def work!
    File.open(@path).each_line do |line|
      parser = Metscola::Parser.new(line)
      @summary.add(parser)
    end
    @summary.flush!
  end

  def summary
    @summary
  end
end
