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


''subroutine for reading configuration ASCII file
declare sub reads_configuration_ascii_file(file_name as string, _
                                           text_file_array() as string)

''subroutine for writing configuration ASCII file
declare sub writes_configuration_ascii_file(file_name as string, _
                                            text_file_array() as string)

''subroutine for reading code ASCII file
declare sub reads_code_ascii_file(file_name as string, _
                                  text_file_array() as string, _
                                  max_cols as integer)

''subroutine for reading normal ASCII file
declare sub reads_normal_ascii_file(file_name as string)

''subroutine for writing ASCII file
declare sub writes_ascii_file(file_name as string, _
                              text_file_array() as string)

''function for viewing files list in a specified directory
declare function list_files(byref filespec as string, _
                            byval attrib as integer) as integer


''subroutine for reading configuration ASCII file
sub reads_configuration_ascii_file(file_name as string, _
                                   text_file_array() as string)
  dim i as integer
  dim file_number as long
  file_number = freefile
  open file_name for input  encoding "ascii" as #file_number
    dim error_type as string
    error_type = check_error(err)
    if error_type = "no error" then
      cls 2
      i = 0
      do
        i += 1
        redim preserve text_file_array(1 to i, 1 to 2)
        input #file_number, text_file_array(i, 1), text_file_array(i, 2)
      loop until eof(file_number)
      close #file_number
    else
      print error_type
      print ""
      print "------------------"
      print ""
      print "Press any key to continue . . ."
      if getkey then
        cls 2
        locate 1, 1
      else
      end if
    end if
end sub

''subroutine for writing configuration ASCII file
sub writes_configuration_ascii_file(file_name as string, _
                                    text_file_array() as string)
  dim file_number as long
  file_number = freefile
  open file_name for output encoding "ascii" as #file_number
    dim error_type as string
    error_type = check_error(err)
    if error_type = "no error" then
      cls 2
      for i as integer = 1 to ubound(text_file_array)
        write #file_number, text_file_array(1, 1), text_file_array(1, 2)
      next i
      close #file_number
    else
      print error_type
      print ""
      print "------------------"
      print ""
      print "Press any key to continue . . ."
      if getkey then
        cls 2
        locate 1, 1
      else
      end if
    end if
end sub

''subroutine for reading code ASCII file
sub reads_code_ascii_file(file_name as string, _
                          text_file_array() as string, _
                          max_cols as integer)
  dim as integer breack1, breack2
  dim as string buffer = ""
  dim i as integer
  dim file_number as long
  file_number = freefile
  open file_name for input  encoding "ascii" as #file_number
    dim error_type as string
    error_type = check_error(err)
    if error_type = "no error" then
      i = 0
      do
        breack1 = 1
        breack2 = 1
        i += 1
        redim preserve text_file_array(1 to i)
        line input #file_number, text_file_array(i)
        
        ''line lenght check
        do until (len(text_file_array(i)) <= max_cols - 1)
          buffer = text_file_array(i)
          breack2 = instrrev(mid(buffer, breack1, max_cols - 3), " ")
          text_file_array(i) = _
                        mid(buffer, breack1, breack2 - breack1) & " _"
          i += 1
          redim preserve text_file_array(1 to i)
          text_file_array(i) = mid(buffer, breack2)
          breack1 = breack2 
        loop

      loop until eof(file_number)
      close #file_number
    else
      cls 2
      print error_type
      print ""
      print "------------------"
      print ""
      print "Press any key to continue . . ."
      if getkey then
        cls 2
        locate 1, 1
      else
      end if
    end if
end sub

''subroutine for reading normal ASCII file
sub reads_normal_ascii_file(file_name as string)
  dim text_line as string
  dim file_number as long
  file_number = freefile
  open file_name for input  encoding "ascii" as #file_number
    dim error_type as string
    error_type = check_error(err)
    if error_type = "no error" then
      cls 2
      do
        line input #file_number, text_line
        print text_line
      loop until eof(file_number)
      close #file_number
    else
      print error_type
    end if
end sub

''subroutine for writing ASCII file
sub writes_ascii_file(file_name as string, text_file_array() as string)
  dim file_number as long
  file_number = freefile
  open file_name for output encoding "ascii" as #file_number
    for i as integer = lbound(text_file_array) to _
                       ubound(text_file_array)
      print #file_number, text_file_array(i)
    next i
  close #file_number
end sub

''function for viewing files list in a specified directory
function list_files(byref filespec as string, _
                    byval attrib as integer) as integer

  dim as integer i = 0
  
  ''Start a file search with the specified filespec/attrib
  ''*AND* get the first filename
  dim as string filename = dir(filespec, attrib)

  ''if len(filename) is 0, exit the loop: no more filenames
  ''are left to be read
  do while Len(filename) > 0
    i += 1
    print filename,
    ''search for (and get) the next item matching the initially
    ''specified filespec/attrib
    filename = dir()
  loop
  print ""
  return i

end function
