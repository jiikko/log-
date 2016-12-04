class Metscola::Runner
  def initialize(paths)
    @paths = paths
  end

  def work
    if @paths.is_a?(String)
      worker = Metscola::Worker.new(@paths)
      worker.work!
      worker.to_tempfile
    else
      Parallel.map(@paths, in_processes: Metscola::CONCURRENCY) do |path|
        worker = Metscola::Worker.new(path)
        worker.work!
        worker.to_tempfile
      end
    end
  end
end
