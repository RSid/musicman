require 'sinatra'
require 'pry'
require 'shotgun'

enable :sessions

def note_validator (note_array)
  if note_array != nil
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

end

def note_step(note_and_vertpos) #interval?
  alphabet = ['c','d','e','f','g','a','b']

  note = note_and_vertpos[0]
  vertpos = note_and_vertpos[-1].to_i

  if (alphabet.index(note) + 2) < alphabet.length
    (alphabet[(alphabet.index(note) + 2)]) + '/' + vertpos.to_s
  elsif (alphabet.index(note) + 1) < alphabet.length
    alphabet[0] + '/' + (vertpos+1).to_s
  else
    alphabet[1] + '/' + (vertpos+1).to_s
  end
end

def chordify_note (note_string,vertpos)
  note = note_string[0]
  full_note = note + '/' + vertpos
  note_array = [full_note]
  alphabet = ('a'..'g').to_a

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

  end
  note_array
end

def chord_or_note (note_array,vertpos)
  final_note_array = []
    note_array.each do |note_string|
      if note_string.include? "chord"
        final_note_array << chordify_note(note_string,vertpos)
      else
        final_note_array << [note_string + '/' + vertpos]
      end
    end
  final_note_array
end


get '/' do
  @note_array = note_validator(session[:notes])
  @numbeats = session[:numbeats]

  erb :index
end

post '/' do
  session.clear
  session[:numbeats] = "#{params["numbeats"]}"
  note_array = (params["notes"]).split(',')
  session[:notes] = chord_or_note(note_array,"4")


  redirect '/'
end
