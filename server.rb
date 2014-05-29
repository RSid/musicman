require 'sinatra'
require 'pry'
require 'shotgun'

enable :sessions


get '/' do

  @note=session[:note]

  erb :index
end

post '/' do
  session[:timesig]="#{params["timesignature"]}"
  session[:note]="#{params["note"]}/#{session[:timesig]}"

  redirect '/'
end
