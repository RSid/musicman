require 'sinatra'

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
      elsif note.is_a?(Array)
        note.each do |sub_note|
          unless sub_note[0] != " "
            return false
          end
        end
      end
    end
  end

end

def note_step(note_and_vertpos,num_half_steps)
  alphabet = ['c','d','e','f','g','a','b']
  half_steps = ['c#','d#','e#','f#','g#','a#','b#']
  keys = alphabet.zip(half_steps).flatten
  #cmaj = c,e,g
  #cmin = c,d#,g

  note = note_and_vertpos[0]
  vertpos = note_and_vertpos[-1].to_i

  if (keys.index(note) + num_half_steps) < keys.length
     (keys[(keys.index(note) + num_half_steps)]) + '/' + vertpos.to_s
  elsif (keys.index(note) + 1) < keys.length
     keys[0] + '/' + (vertpos + 1).to_s
  else
    keys[1] + '/' + (vertpos + 1).to_s
  end
end

def chordify_note (note_string,vertpos)
  note = note_string[0]
  full_note = note + '/' + vertpos
  note_array = [full_note]
  alphabet = ('a'..'g').to_a


  if note_string.include? "min"
    #minor chord, 3/4
    middle_note = note_step(full_note,5)
    note_array << middle_note
    note_array << note_step(middle_note,4)

  else
    #majorchord, 4/3
    middle_note = note_step(full_note,4)
    note_array << middle_note
    note_array << note_step(middle_note,4)

  end
  note_array
end

def chord_or_note (note_array,vertpos)
  final_note_array = []
    note_array.each do |note_string|
      if note_string[0]==" "
        note_string[0]=""
      end
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
  binding.pry
  erb :index
end

post '/' do
  session.clear
  session[:numbeats] = "#{params["numbeats"]}"
  note_array = (params["notes"]).split(',')
  session[:notes] = chord_or_note(note_array,"4")


  redirect '/'
end
