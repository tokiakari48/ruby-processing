require_relative '../runners/base'

module Processing
  # A sketch loader, observer, and reloader, to tighten
  # the feedback between code and effect.
  class Watcher
    # Sic a new Processing::Watcher on the sketch
    SLEEP_TIME = 0.2
    def initialize
      reload_files_to_watch
      @time = Time.now
      start_watching
    end

    # Kicks off a thread to watch the sketch, reloading Ruby-Processing
    # and restarting the sketch whenever it changes.
    def start_watching
      start_runner
      Kernel.loop do
        if @files.find { |file| FileTest.exist?(file) && File.stat(file).mtime > @time }
          puts 'reloading sketch...'
          $app && $app.close
          @time = Time.now
          java.lang.System.gc
          start_runner
          reload_files_to_watch
        end
        sleep SLEEP_TIME
      end
    end

    # Convenience function to report errors when loading and running a sketch,
    # instead of having them eaten by the thread they are loaded in.
    def report_errors
      yield
    rescue Exception => e
      wformat = 'Exception occured while running sketch %s...'
      tformat = "Backtrace:\n\t%s"
      warn format(wformat, File.basename(SKETCH_PATH))
      puts format(tformat, e.backtrace.join("\n\t"))
    end

    def start_runner
      @runner.kill if @runner && @runner.alive?
      @runner = Thread.start do
        report_errors do
          Processing.load_and_run_sketch
        end
      end
    end

    def reload_files_to_watch
      @files = Dir.glob(File.join(SKETCH_ROOT, '**/*.rb'))
    end
  end
end

Processing::Watcher.new
