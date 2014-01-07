windows = false
platform = RUBY_PLATFORM.split("-")[1]
windows = true if platform =~ /mswin32/ or platform =~ /mingw32/

module Qt
  PLUGIN_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', 'qtbin', 'plugins'))
end
ENV['PATH'] = File.join(File.dirname(__FILE__), '../qtbin') + ';' + File.join(File.dirname(__FILE__), '../qtbin/plugins') + ';' + File.join(File.dirname(__FILE__), '../qtbin/1.9') + ';' + ENV['PATH']
