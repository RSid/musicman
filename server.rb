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

def note_step(note, step_count)
  alphabet = ('a'..'z').to_a
  note_index = alphabet.index(note) + 2
  next_note_index = note_index + step_count

  alphabet[next_note_index]
end

def chordify_note (note_string,timesig_string)
  note=note_string[0]
  note_array=[(note+'/' +timesig_string)]
  alphabet=('a'..'z').to_a

  middle_note = alphabet[((alphabet.index(note)) + 2 )]
  last_note = alphabet[((alphabet.index(note)) + 4 )]

  # notes = []
  # alphabet.each_with_index do |letter, index|
  #   if index == 0
  #     notes << letter
  # end

  if note_string.include? "min"
    #minor chord, 3/4
    note_array << ((note.next +  "\#") + '/' + timesig_string)
    note_array << (note.next + '/' + timesig_string)

  else
    #major chord, 1,3,5, note to people that it defaults to major
    note_array << (middle_note + '/' + timesig_string)
    note_array << (last_note + '/' + timesig_string)

    # alphabet[((alphabet.index(note)) + 4 )]
  end
  note_array
end

def chord_or_note (note_string,timesig_string)
  if note_string.include? "chord"
    return_note=chordify_note(note_string,timesig_string)
  else
    return_note=note_string + '/' + timesig_string
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
  session[:note] = chord_or_note(params["note"],session[:timesig])
  session[:note2] = chord_or_note(params["note2"],session[:timesig])
  session[:note3] = chord_or_note(params["note3"],session[:timesig])
  session[:note4] = chord_or_note(params["note4"],session[:timesig])


  redirect '/'
end
