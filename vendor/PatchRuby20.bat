IF [%1]==[] (
  set /p RUBY_INSTALL="Enter Ruby 2.0 Install Directory as an absolute path [C:\Ruby200p648]: "
  IF "!RUBY_INSTALL!"=="" (
    set RUBY_INSTALL=C:\Ruby200p648
  )
) else (
  set RUBY_INSTALL=%~1
)

copy /y Ruby20\include\ruby-2.0.0\ruby\* %RUBY_INSTALL%\include\ruby-2.0.0\ruby
