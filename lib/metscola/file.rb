class Metscola::File
  attr_reader :file

  def initialize(path)
    if [Tempfile, File].include?(path.class)
      @file = path
      return
    end

    # check ftype if path is String
    @file =
      case FileMagic.new.file(path)
      when /gzip/
        require 'zlib'
        Zlib::GzipReader.open(path)
      when /text/
        File.open(path)
      else
        raise 'unkown file type.'
      end
  end

  # FIXME fat memory
  def each_line(&block)
    each_line_with_sort_by_time.each(&block)
  end

  protected

  def each_line_with_sort_by_time
    list = []
    @file.each_line do |line|
      time = line.scrub('').split("\t").first
      list << { time: time, line: line }
    end
    list.
      sort_by { |time_with_line| time_with_line[:time] }.
      map { |time_with_line| time_with_line[:line] }
  end
end
