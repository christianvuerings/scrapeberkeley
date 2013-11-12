# require "sinatra"

# get "/" do
#   "Test 123"
# end

require 'sinatra/base'

class MyApp < Sinatra::Base
  set :sessions, true
  set :foo, 'bar'

  get '/' do
    'Hello world!'
  end

  run! if app_file == $0
end
