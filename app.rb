require 'sinatra'
require 'sqlite3'
require './db/todos'
require 'json'

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

delete '/todos/:id' do
  id = params[:id]
  DB.execute('DELETE FROM todos WHERE id = ?', [id])
  redirect '/todos'
end

get '/api/todos' do
  content_type :json
  rows = DB.execute('SELECT * FROM todos')
  todos = rows.map { |r| { 'id' => r[0], 'title' => r[1], 'created_at' => r[2] } }
  JSON.pretty_generate(todos)
end

post '/api/todos' do
  content_type :json
  title = params['title']

  DB.execute('INSERT INTO todos (title) VALUES (?)', [title])
  id = DB.last_insert_row_id
  row = DB.execute('SELECT * FROM todos WHERE id = ?', [id]).first
  todo = { 'id' => row[0], 'title' => row[1], 'created_at' => row[2] }
  JSON.pretty_generate(todo)
end

get '/api/todos/:id' do
  content_type :json
  id = params[:id]
  row = DB.execute('SELECT * FROM todos WHERE id = ?', [id]).first
  todo = row ? { 'id' => row[0], 'title' => row[1], 'created_at' => row[2] } : {}
  JSON.pretty_generate(todo)
end

put '/api/todos/:id' do
  content_type :json
  id = params[:id]
  title = params['title']

  DB.execute('UPDATE todos SET title = ? WHERE id = ?', [title, id])
  row = DB.execute('SELECT * FROM todos WHERE id = ?', [id]).first
  todo = row ? { 'id' => row[0], 'title' => row[1], 'created_at' => row[2] } : {}
  JSON.pretty_generate(todo)
end

delete '/api/todos/:id' do
  content_type :json
  id = params[:id]
  DB.execute('DELETE FROM todos WHERE id = ?', [id])
  res = { 'message' => 'TODO deleted' }
  JSON.pretty_generate(res)
end
