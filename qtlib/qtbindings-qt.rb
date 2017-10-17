windows = false
platform = RUBY_PLATFORM.split("-")[1]
windows = true if platform =~ /mswin32/ or platform =~ /mingw32/

module Qt
  PLUGIN_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', 'qtbin', 'plugins'))
end
ENV['PATH'] = File.join(File.dirname(__FILE__), '../qtbin') + ';' + File.join(File.dirname(__FILE__), '../qtbin/plugins') + ';' + ENV['PATH']
begin
  require 'ruby_installer'
  RubyInstaller::Runtime.add_dll_directory(File.join(File.dirname(__FILE__), '../qtbin'))
  RubyInstaller::Runtime.add_dll_directory(File.join(File.dirname(__FILE__), '../qtbin/plugins'))
rescue
  # Oh well - Hopefully not Ruby 2.4+ on windows
end
