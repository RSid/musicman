require 'sinatra'
require 'pry'
require 'shotgun'

enable :sessions


get '/' do

  @note=session[:note]
  @note2=session[:note2]
  @note3=session[:note3]
  @note4=session[:note4]
  @timesig=session[:timesig]

  erb :index
end

post '/' do
  session[:timesig]="#{params["timesignature"]}"
  session[:note]="#{params["note"]}/#{session[:timesig]}"
  session[:note2]="#{params["note2"]}/#{session[:timesig]}"
  session[:note3]="#{params["note3"]}/#{session[:timesig]}"
  session[:note4]="#{params["note4"]}/#{session[:timesig]}"


  redirect '/'
end
