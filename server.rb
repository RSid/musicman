require 'sinatra'
require 'pry'
require 'shotgun'

enable :sessions


get '/' do

  @note=session[:note]

  erb :index
end

post '/' do
  session[:note]="#{params["note"]}/4"

  redirect '/'
end
