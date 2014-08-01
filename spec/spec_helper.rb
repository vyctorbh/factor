# encoding: UTF-8

require 'codeclimate-test-reporter'
require 'stringio'

CodeClimate::TestReporter.start do
  add_filter '/spec/'
end

# include anything that could be tested
require 'commands/base'
require 'commands/workflows'
require 'listener'
require 'runtime'
require 'websocket_manager'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

def capture_stdout(&_block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end