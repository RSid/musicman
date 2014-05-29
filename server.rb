require 'sinatra'
require 'pry'
require 'shotgun'


get '/' do
  @note="c/4"

  erb :index
end
