require 'sinatra'
require 'sqlite3'
require './db/todos'

get '/' do
  'Hello, World!'
end

get '/todos' do
  @todos = DB.execute('SELECT * FROM todos')
  erb :todos
end

post '/todos' do
  title = params['title']
  DB.execute('INSERT INTO todos (title) VALUES (?)', [title])
  redirect '/'
end
