windows = false
platform = RUBY_PLATFORM.split("-")[1]
windows = true if platform =~ /mswin32/ or platform =~ /mingw32/

begin
  require 'thread'
  require 'qtbindings-qt'
rescue LoadError
  # Oh well - Hopefully not using the Windows binary gem
end

if RUBY_VERSION.split('.')[0].to_i == 1
  if windows
    ENV['PATH'] = File.join(File.dirname(__FILE__), '../bin') + ';' + File.join(File.dirname(__FILE__), '../lib/1.9') + ';' + File.join(File.dirname(__FILE__), '../bin/1.9') + ';' + ENV['PATH']
  end
  $: << File.join(File.dirname(__FILE__), '../lib/1.9')
  require '1.9/qtruby4'
else
  if windows
    ENV['PATH'] = File.join(File.dirname(__FILE__), '../bin') + ';' + File.join(File.dirname(__FILE__), '../lib/2.0') + ';' + File.join(File.dirname(__FILE__), '../bin/2.0') + ';' + ENV['PATH']
  end
  $: << File.join(File.dirname(__FILE__), '../lib/2.0')
  require '2.0/qtruby4'
end

module Qt
  class RubyThreadFix < Qt::Object
    slots 'ruby_thread_timeout()'
    slots 'callback_timeout()'
    slots 'callback_timeout2()'
    @@queue  = Queue.new

    def initialize
      super()
      # Enable threading
      @ruby_thread_sleep_period = 0.01
      @ruby_thread_timer = Qt::Timer.new(self)
      connect(@ruby_thread_timer, SIGNAL('timeout()'), SLOT('ruby_thread_timeout()'))
      @ruby_thread_timer.start(0)
      @callback_timer = Qt::Timer.new(self)
      connect(@callback_timer, SIGNAL('timeout()'), SLOT('callback_timeout()'))
      @callback_timer.start(1)
      @callback_timer2 = Qt::Timer.new(self)
      connect(@callback_timer2, SIGNAL('timeout()'), SLOT('callback_timeout2()'))
      @running = true
    end

    def ruby_thread_timeout
      sleep(@ruby_thread_sleep_period)
    end

    def callback_timeout
      if !@@queue.empty?
        # Start a backup timer in case this one goes modal.
        @callback_timer2.start(100)
        @@queue.pop.call until @@queue.empty?
        # Cancel the backup timer
        @callback_timer2.stop if @callback_timer2
      end
    end

    def callback_timeout2
      @callback_timer2.interval = 10
      @@queue.pop.call until @@queue.empty?
    end

    def self.queue
      @@queue
    end

    def stop
      if @running
        @running = false
        @ruby_thread_timer.stop
        @callback_timer.stop
        @callback_timer2.stop
        @ruby_thread_timer.dispose
        @callback_timer.dispose
        @callback_timer2.dispose
        @ruby_thread_timer = nil
        @callback_timer = nil
        @callback_timer2 = nil
      end
    end
  end

  # Code which accesses the GUI must be executed in the main QT GUI thread.
  # This method allows code in another thread to execute safely in the main GUI
  # thread. By default it will block the main GUI thread until the code in the
  # block completes althought this can be changed by passing false for the
  # first parameter.
  #
  # @param blocking [Boolean] Whether to block the main thread until the code
  #   in the block finishing executing. If false the main thread will be
  #   allowed to continue and the block code will execute in parallel.
  # @param sleep_period [Float] The amount of time to sleep between checking
  #   whether the code in the block has finished executing
  # @param delay_execution [Boolean] Only used if called from the main GUI
  #   thread. Allows the block to be executed in parallel with the main thread.
  def self.execute_in_main_thread (blocking = true, sleep_period = 0.001, delay_execution = false)
    if Thread.current != Thread.main
      complete = false
      RubyThreadFix.queue << lambda {|| yield; complete = true}
      if blocking
        until complete
          sleep(sleep_period)
        end
      end
    else
      if delay_execution
        RubyThreadFix.queue << lambda {|| yield; complete = true}
      else
        yield
      end
    end
  end

end # module Qt
