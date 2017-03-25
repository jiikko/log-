class Metscola::Runner
  def initialize(path)
    @path = path
  end

  def work
    if @path.is_a?(String)
      worker = Metscola::Worker.new(@path)
      worker.work!
      worker.to_tempfile
    else
      Parallel.map(@path, in_processes: Metscola::CONCURRENCY) do |path|
        worker = Metscola::Worker.new(path)
        worker.work!
        worker.to_tempfile
      end
    end
  end
end
