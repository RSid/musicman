require 'sinatra'
require 'pry'
require 'shotgun'

enable :sessions

def note_validator (note_array)
  note_array.each do |note|

    if note.is_a?(String)
      unless ("a".."g").include? note[0]
       return false
      end
    elsif note.is_a?(Array)

      note.each do |sub_note|
        unless ("a".."g").include? sub_note[0]
          return false
        end
      end
    end
  end
end

def chordify_note (note_string,timesig_string)
  note=note_string[0]
  note_array=[(note+'/'+timesig_string)]

  if note_string.include? "min"
    #minor chord, 3/4
    #need to figure out good way to count alphabet in half-steps
    note_array<<((note.next +  "\#")+'/'+timesig_string)
    note_array<<(note.next+'/'+timesig_string)

  else
    #major chord, 4/3, note to people that it defaults to major
    note_array<<(note.next+'/'+timesig_string)
    note_array<<((note.next +  "\#")+'/'+timesig_string)

  end
  note_array
end

def chord_or_note (note_string,timesig_string)
  return_note=nil
  if note_string.include? "chord"
    return_note=chordify_note(note_string,timesig_string)
  else
    return_note=note_string + '/' + timesig_string
  end
  return_note
end


get '/' do
  @note_array=note_validator([session[:note],session[:note2],session[:note3],session[:note4]])
    binding.pry
  @timesig=session[:timesig]

  erb :index
end

post '/' do
  session[:timesig] = "#{params["timesignature"]}"
  session[:note] = chord_or_note(params["note"],session[:timesig])
  session[:note2] = chord_or_note(params["note2"],session[:timesig])
  session[:note3] = chord_or_note(params["note3"],session[:timesig])
  session[:note4] = chord_or_note(params["note4"],session[:timesig])


  redirect '/'
end
