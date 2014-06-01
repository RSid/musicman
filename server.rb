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

def note_step(note_and_vertpos) #interval
  alphabet = ['c','d','e','f','g','a','b']

  note=note_and_vertpos[0]
  vertpos=note_and_vertpos[-1].to_i

  if (alphabet.index(note) + 2)<alphabet.length
    (alphabet[(alphabet.index(note) + 2)]) + '/' + vertpos.to_s
  elsif (alphabet.index(note) + 1)<alphabet.length
    alphabet[0] + '/' + (vertpos+1).to_s
  else
    alphabet[1] + '/' + (vertpos+1).to_s
  end
end

def chordify_note (note_string,vertpos)
  note=note_string[0]
  full_note=note+'/' +vertpos
  note_array=[full_note]
  alphabet=('a'..'g').to_a

  middle_note =  note_step(full_note)
  last_note =  note_step(middle_note)



  if note_string.include? "min"
    #minor chord, 3/4
    note_array << (middle_note)
    note_array << (last_note)

  else
    #major chord, 1,3,5, note to people that it defaults to major
    note_array << (middle_note)
    note_array << (last_note)

    # alphabet[((alphabet.index(note)) + 4 )]
  end
  note_array
  #binding.pry
end

def chord_or_note (note_string,vertpos)
  if note_string.include? "chord"
    return_note=chordify_note(note_string,vertpos)
  else
    return_note=note_string + '/' + vertpos
  end
  return_note
end


get '/' do
  @note_array=note_validator([session[:note],session[:note2],session[:note3],session[:note4]])
  #@note_array.delete(nil)
  @timesig=session[:timesig]

  erb :index
end

post '/' do
  session.clear
  session[:timesig] = "#{params["timesignature"]}"
  session[:note] = chord_or_note(params["note"],"4")
  session[:note2] = chord_or_note(params["note2"],"4")
  session[:note3] = chord_or_note(params["note3"],"4")
  session[:note4] = chord_or_note(params["note4"],"4")


  redirect '/'
end
