require 'sinatra'
require 'pg'
require 'pry'
require 'sinatra/contrib/all' if development?

get '/' do
  erb :index
end

get '/links/new' do
  erb :new
end

get '/links/:id' do
  sql = "SELECT * FROM links WHERE id = #{params[:id]}"
  @link = sql_run(sql).first

  erb :show
end

get '/links/:id/edit' do
  sql = "SELECT * from links where id = #{params[:id]}"
  @item = sql_run(sql).first

  erb :edit
end

post '/links/:id' do
  sql = "UPDATE links SET url = '#{params[:url]}', title = '#{params[:title]}', genre = '#{params[:genre]}', details = '#{params[:details]}' where id = #{params[:id]}"
  sql_run(sql)

  redirect to("links/#{params[:id]}")
end

get '/links' do 

  if params[:search]
    sql = "SELECT * FROM links WHERE genre = '#{params[:search]}' OR URL LIKE '%#{params[:search]}%'"
    @search = sql_run(sql)
  else
    sql = 'SELECT * FROM links'
    @links = sql_run(sql)
  end

  erb :links
end

post '/links' do
  sql = "INSERT INTO links (url, title, genre, details) VALUES ('#{params[:url]}', '#{params[:title]}', '#{params[:genre]}', '#{params[:details]}')"
  sql_run(sql)

  redirect to('/links')
end

post '/links/:id/delete' do 
  sql = "DELETE FROM links WHERE id = #{params[:id]}"
  sql_run(sql)

  redirect to('/links')
end


private

def sql_run(sql)
  conn = PG.connect(dbname: 'bookmarker', host: 'localhost')
  begin
    result = conn.exec(sql)
  ensure
    conn.close
  end
  result
end
