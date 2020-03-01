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


''subroutine for reading keywords
declare sub reads_keywords(file_name as string, keywords() as string)

''subroutine for to highlight the keywords
declare sub highlights_keywords(text_file_array() as string, _
                                viewprint_rows as uinteger, _
                                byref scrolling as integer)


''subroutine for reading keywords
sub reads_keywords(file_name as string, keywords() as string)
  dim as integer i = 0
  dim file_number as long
  file_number = freefile
  open file_name for input  encoding "ascii" as #file_number
    dim error_type as string
    error_type = check_error(err)
    if error_type = "no error" then
      do
        i += 1
        redim preserve keywords(1 to i)
        line input #file_number, keywords(i)
      loop until eof(file_number)
      close #file_number
    else
      cls 2
      locate 3, 2
      print "Warning!"
      locate 5, 2
      print "doc/clumsy_keywords.txt: " & error_type
      locate 7, 2
      print "Syntax highlighting will not work."
      sleep 5000, 1
      cls 2
    end if
end sub

''subroutine for to highlight the keywords
sub highlights_keywords(text_file_array() as string, _
                        viewprint_rows as uinteger, _
                        byref scrolling as integer)
/'

  This subroutine is not implemented.

'/
end sub
