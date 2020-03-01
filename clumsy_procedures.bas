/'
clumsy is an elementary FreeBASIC IDE for console - beta version
Copyright (C) 2020 Luca Evangelisti
<https://github.com/lucaevangelisti/clumsy>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

Contact: <luca.evangelisti.67@gmail.com>
'/


''shows message
declare sub message(text as string, duration as integer)

''puts key into code array
declare sub puts_key(viewprint_rows as uinteger, max_cols as uinteger, _
                    row as integer, col as integer, key as long, _
                    text_file_array() as string, _
                    byref scrolling as integer)

''erases key (backspace)
declare sub erases_key(row as integer, col as integer, _
                       text_file_array() as string, _
                       viewprint_rows as uinteger, _
                       byref scrolling as integer)

''deletes key (del)
declare sub deletes_key(row as integer, col as integer, _
                        text_file_array() as string, _
                        viewprint_rows as uinteger, _
                        byref scrolling as integer)

''inserts new code line into code array
declare sub new_line(max_rows as uinteger, max_cols as uinteger, _
                     row as integer, col as integer, _
                     text_file_array() as string, _
                     byref scrolling as integer)

''moves corsor
declare sub moves_cursor(row as integer, col as integer, _
                         inc_row as integer, inc_col as integer, _
                         text_file_array() as string, _
                         viewprint_rows as uinteger, _
                         byref scrolling as integer)

''prints code
declare sub prints_code(row as integer, col as integer, _
                        text_file_array() as string, _
                        viewprint_rows as uinteger, _
                        byref scrolling as integer)


'shows message
sub message(text as string, duration as integer)
  cls 2
  locate 1, 1, 1
  print text
  sleep duration, 1
end sub

''puts key into code array
sub puts_key(viewprint_rows as uinteger, max_cols as uinteger, _
            row as integer, col as integer, key as long, _
            text_file_array() as string, _
            byref scrolling as integer)

  if col < max_cols and _
    len(text_file_array(row + scrolling)) < (max_cols - 1) then
    if col <= len(text_file_array(row + scrolling)) then
      text_file_array(row + scrolling) = _
        mid(text_file_array(row + scrolling), 1, col - 1) & _
        chr(key) & mid(text_file_array(row + scrolling), col)
    else
      text_file_array(row + scrolling) = _
        text_file_array(row + scrolling) & chr(key)
    end if
    prints_code(row, col + 1, text_file_array(), _
                viewprint_rows, scrolling)
  elseif col = max_cols then
    beep
  else
    beep
  end if
end sub

''erases key (backspace)
sub erases_key(row as integer, col as integer, _
               text_file_array() as string, _
               viewprint_rows as uinteger, _
               byref scrolling as integer)
  if col = 1  and row > 1 then
    col = len(text_file_array(row - 1 + scrolling))
    text_file_array(row - 1 + scrolling) = text_file_array(row - 1 + _
                          scrolling) + text_file_array(row + scrolling)
    for i as integer = row  + scrolling to ubound(text_file_array) - 1
      text_file_array(i) = text_file_array(i + 1)
    next i
    redim preserve text_file_array(1 to ubound(text_file_array) - 1)
    prints_code(row - 1, col + 1, text_file_array(), _
                viewprint_rows, scrolling)
  elseif col = 1 and row  + scrolling = 1 then
    ''none
  else
    text_file_array(row + scrolling) = _
                  mid(text_file_array(row + scrolling), 1, col - 2) & _
                  mid(text_file_array(row + scrolling), col)
    prints_code(row, col - 1, text_file_array(), _
                viewprint_rows, scrolling)
  end if
end sub

''deletes key (del)
sub deletes_key(row as integer, col as integer, _
            text_file_array() as string, _
            viewprint_rows as uinteger, _
            byref scrolling as integer)
  if len(text_file_array(row + scrolling)) = 0 then
    if row + scrolling < ubound(text_file_array) then
      ''deletes line
      for i as integer = row + scrolling to ubound(text_file_array) - 1
        text_file_array(i) = text_file_array(i +1)
      next i
      redim preserve text_file_array(1 to ubound(text_file_array) - 1)
    else
      ''none
    end if
  elseif col > len(text_file_array(row + scrolling)) and _
         row + scrolling < ubound(text_file_array) then
    ''scrolls up the lines
    text_file_array(row + scrolling) = _
                                text_file_array(row + scrolling) & _
                                text_file_array(row + scrolling + 1)
    for i as integer = row + _
                       scrolling + 1 to ubound(text_file_array) - 1
      text_file_array(i) = text_file_array(i + 1)
    next i
    redim preserve text_file_array(1 to ubound(text_file_array) - 1)
  else
    ''deletes character into the line
    text_file_array(row + scrolling) = _
                  mid(text_file_array(row + scrolling), 1, col - 1) & _
                  mid(text_file_array(row + scrolling), col + 1) 
  end if
  prints_code(row, col, text_file_array(), viewprint_rows, scrolling)
end sub

''inserts new code line into code array
sub new_line(viewprint_rows as uinteger, max_cols as uinteger, _
             row as integer, col as integer, _
             text_file_array() as string, _
             byref scrolling as integer)
  
  if row + scrolling = ubound(text_file_array) and _
     col > len(text_file_array(row)) then
    ''last line code
    redim preserve text_file_array(1 to ubound(text_file_array) + 1)
    text_file_array(ubound(text_file_array)) = ""
  else
    ''insert line
    redim preserve text_file_array(1 to ubound(text_file_array) + 1)
    for i as integer = ubound(text_file_array) to _
                       (row + 1 +scrolling) step -1
      text_file_array(i) = text_file_array(i - 1)
    next i
    text_file_array(row + 1 + scrolling) = _
                      mid(text_file_array(row + scrolling), col)      
    text_file_array(row + scrolling) = _
                      mid(text_file_array(row + scrolling), 1, col - 1)
  end if

  ''check scrolling
  if row = viewprint_rows Then
    scrolling += 1
  else
  end if

  ''print
  prints_code(row + 1, 1, text_file_array(), viewprint_rows, scrolling)

end sub

''moves corsor
sub moves_cursor(row as integer, col as integer, _
                 inc_row as integer, inc_col as integer, _
                 text_file_array() as string, _
                 viewprint_rows as uinteger, _
                 byref scrolling as integer)
  if inc_col <> 0 then ''horizontal moving
    if col + inc_col <= len(text_file_array(row + scrolling)) then
      locate row, col + inc_col
    else
      locate row, len(text_file_array(row + scrolling)) + 1
    end if  
  else ''vertical moving
    if row + inc_row < 1 and scrolling > 0 then
      ''scroll back
      scrolling -= 1
      if col <= len(text_file_array(row + inc_row + scrolling)) then
        prints_code(row, col, _
                 text_file_array(), viewprint_rows, scrolling)
      else
        prints_code(row, _
                 len(text_file_array(row + inc_row + scrolling)) + 1, _
                 text_file_array(), viewprint_rows, scrolling)
      end if
    elseif row + inc_row > viewprint_rows and _
           scrolling + row + inc_row <= ubound (text_file_array) then
      ''scroll forward
      scrolling += 1
      if col <= len(text_file_array(row + inc_row + scrolling)) then
        prints_code(row, col, _
                 text_file_array(), viewprint_rows, scrolling)
      else
        prints_code(row, _
                 len(text_file_array(row + inc_row + scrolling)) + 1, _
                 text_file_array(), viewprint_rows, scrolling)
      end if
    else
      ''scroll inside
      if row + inc_row + scrolling <= ubound(text_file_array) then
        if col <= len(text_file_array(row + inc_row + scrolling)) then
          locate row + inc_row, col
        else
          locate row + inc_row, _
                 len(text_file_array(row + inc_row + scrolling)) + 1
        end if
      else
        locate row, col
      end if
    end if
  end if
end sub

''prints code
sub prints_code(row as integer, col as integer, _
                text_file_array() as string, _
                viewprint_rows as uinteger, _
                byref scrolling as integer)
  cls 2
  for i as integer = 1 to viewprint_rows
    locate i, 1, 1
    if i + scrolling <= ubound(text_file_array) then
      print text_file_array(i + scrolling);
    else
      exit for
    end if
  next i
  locate row, col
  
  ''highlights the keywords
  ''highlights_keywords(text_file_array(), viewprint_rows, scrolling)

end sub
