require 'sinatra'
require 'pry'
require 'shotgun'

enable :sessions

def note_validator (note_array)
  note_array.each do |note|
    unless ("a".."g").include? note[0]
     return false
    end
  end
end


get '/' do

  @note_array=note_validator([session[:note],session[:note2],session[:note3],session[:note4]])

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
