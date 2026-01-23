require 'spec_helper'
require 'rack/test'
require 'json'
require_relative '../../app'

RSpec.describe 'API: TODOリスト操作', clear_db: true do
  include Rack::Test::Methods

  before(:all) do
    start_server
  end

  after(:all) do
    stop_server
  end

  let(:test_todo) { { title: 'テスト用TODO' } }
  let!(:todo_id) do
    DB.execute('INSERT INTO todos (title) VALUES (?)', [test_todo[:title]])
    DB.last_insert_row_id
  end

  describe 'GET /api/todos/:id' do
    it '指定したIDのTODOを取得できること' do
      get "/api/todos/#{todo_id}"

      expect(response).to have_http_status(200)
      body = JSON.parse(last_response.body)
      expect(body).to be_a(Hash)
      expect(body['id']).to eq(todo_id)
      expect(body['title']).to eq('テスト用TODO')
    end
  end

  describe 'GET /api/todos' do
    it 'TODO の一覧を取得する' do
      get '/api/todos'

      expect(response).to have_http_status(200)
      body = JSON.parse(last_response.body)
      expect(body).to be_a(Array)
      # 先に登録された todo_id を含んでいること
      ids = body.map { |t| t['id'] }
      expect(ids).to include(todo_id)
      todo = body.find { |t| t['id'] == todo_id }
      expect(todo['title']).to eq('テスト用TODO')
    end
  end
end
