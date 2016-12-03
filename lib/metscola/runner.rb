class Metscola::Runner
  MASTER_CONCURRENCY = 4
  SUMMARY_RANGE = 60

  def initialize(paths)
    @masters = []
    @queue = Queue.new(4)
    build_master_process!
    paths.each { |path| @queue.push(path) }
  end

  def import
  end

  private

  def build_master_process!
    @masters = []
    1.times do
      @masters << Master.new(@queue)
    end
  end
end
