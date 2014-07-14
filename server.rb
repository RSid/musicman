require 'sinatra'

enable :sessions

def note_validator (note_array)
  if note_array != nil
    note_array.each do |note|
      if note.is_a?(String)
        unless ("a".."g").include? note[0].downcase
         return false
        end
      elsif note.is_a?(Array)
        note.each do |sub_note|
          unless ("a".."g").include? sub_note[0].downcase
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
  keys = ['c', 'c#', 'd','d#', 'e','f','f#',
    'g','g#','a','a#','b']

  if note_and_vertpos.include?('#')
    note = note_and_vertpos[0..1].downcase
  else
    note = note_and_vertpos[0].downcase
  end
  vertpos = note_and_vertpos[-1].to_i
  note_position_in_scale = keys.index(note)

  if (note_position_in_scale + num_half_steps) < keys.length
     (keys[ (note_position_in_scale + num_half_steps) ]) + '/' + vertpos.to_s
  else
    ( keys[ ( (note_position_in_scale + num_half_steps)%keys.length ) ] ) + '/'
      + (vertpos + 1).to_s
  end
end

def chordify_note (note_string,vertpos)
  if note_string.include?('#')
    note = note_string[0..1].downcase
  else
    note = note_string[0].downcase
  end
  full_note = note + '/' + vertpos
  note_array = [full_note]
  alphabet = ('a'..'g').to_a

  if note_string.include? "min"
    #minor chord, 3/4
    middle_note = note_step(full_note,3)
    note_array << middle_note
    note_array << note_step(middle_note,4)
  else
    #majorchord, 4/3
    middle_note = note_step(full_note,4)
    note_array << middle_note
    note_array << note_step(middle_note,3)
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

####################
#CONTROLLERS/ROUTES
####################

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
