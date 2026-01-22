require 'sinatra'

get '/' do
  'Hello, World!'
end

require './db/todos'
get '/todos' do
  @todos = DB.execute('SELECT * FROM todos')
  erb :todos
end
