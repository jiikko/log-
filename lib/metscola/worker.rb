class Metscola::Worker
  def initialize(path, position)
    @path = path
    @position = position
    @map = {}
  end

  def work!
    File.open(path).each_line do |line|
      parser = Metscola::Parser.new(line)
    end
  end
end
