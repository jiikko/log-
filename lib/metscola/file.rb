class Metscola::File
  attr_reader :file

  def initialize(path)
    @file = File.open(path)
  end

  # FIXME fat memory
  def each_line(&block)
    each_line_with_sort_by_time.each(&block)
  end

  protected

  def each_line_with_sort_by_time
    list = []
    @file.each_line do |line|
      time = line.split("\t").first
      list << { time: time, line: line }
    end
    list.
      sort_by { |time_with_line| time_with_line[:time] }.
      map { |time_with_line| time_with_line[:line] }
  end
end
