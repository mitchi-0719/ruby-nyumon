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

get '/todos/:id/edit' do
  @todo = DB.execute('SELECT * FROM todos WHERE id = ?', [params[:id]]).first
  erb :edit
end

put '/todos/:id' do
  title = params['title']
  id = params[:id]
  puts [title, id]
  DB.execute('UPDATE todos SET title = ? WHERE id = ?', [title, id])
  redirect '/todos'
end
