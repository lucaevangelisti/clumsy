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

''first release: 4th February 2020
''last update: 23th February 2020

#include "dir.bi" ''library for working with directories

#include "clumsy_errors.bas"
#include "clumsy_highlighter.bas"
#include "clumsy_procedures.bas"
#include "clumsy_files.bas"

''arrays
dim configuration_file() as string
dim code_array() as string
dim keywords() as string

''variables
dim as string project_path = "prj/"
dim as string file_name = ""
dim as string source_file_extension = ".bas"
dim as integer choice = 0
dim as string answer = ""
dim as long key ''key entered
dim as integer scrolling = 0
dim as integer row = 1
dim as integer col = 1

''procedures
declare sub initializes_console()
declare function get_max_rows() as integer
declare function get_viewprint_rows() as integer
declare function get_max_cols() as integer
declare sub come_back()
declare sub clumsy_cover()

''start program
initializes_console()
reads_keywords("doc/clumsy_keywords.txt", keywords())
clumsy_cover()

''initializes code_array
redim preserve code_array(1 to 1)
code_array(1) = ""

''main loop
do

  key = getkey

  if key > 255 then ''cursor keys
    key = key shr 8 ''shifts the bits to the right
    
    select case key
      
      case 59 ''F1 new source file
        cls 2
        locate 1, 1, 1
        redim code_array(1 to 1)
        code_array(1) = ""
        file_name = ""
      case 60 ''F2 open source file
        cls 2
        locate 1, 1, 1
        print "Source codes list:"
        print ""
        if list_files("prj/*.bas", fbArchive) > 0 then
          print ""
          input "Insert file name without extension: ", file_name
          if file_name <> "" then
            reads_code_ascii_file(project_path & file_name & _
                                  source_file_extension, _
                                  code_array(), get_max_cols())
            prints_code (1, 1, code_array(), _
                         get_viewprint_rows(), scrolling)
          else
            cls 2
          end if
        else
          print "No source files detected . . ."
        end if

      case 61 ''F3 save source file
        if file_name = "" then
          cls 2
          locate 1, 1, 1
          input "Insert file name without extension (e.g. prj1): ", _
          file_name
        else
        end if
        writes_ascii_file(project_path & file_name & _
                          source_file_extension, code_array())
        row = csrlin
        col = pos
        message("... file saved!", 1000)
        reads_code_ascii_file(project_path & file_name & _
                              source_file_extension, code_array(), _
                              get_max_cols())
        prints_code (row, col, code_array(), _
                     get_viewprint_rows(), scrolling)

      case 62 ''F4
        ''...

      case 63 ''F5 compile and run
        if file_name <> "" then
          reads_configuration_ascii_file("clumsy_configuration.txt", _
                                         configuration_file())
          cls 2
          exec(configuration_file(1, 2), project_path & _
                                      file_name & source_file_extension)
          exec(project_path & file_name, "")
          come_back()
          prints_code(1, 1, code_array(), _
                      get_viewprint_rows(), scrolling)
        else
          cls 2
          print "There isn't a source file to compile!"
          print "You must first write some code and save it."
          come_back()
        end if

      case 64 ''F6
        ''...

      case 65 ''F7 configuration
        reads_configuration_ascii_file("clumsy_configuration.txt", _
                                       configuration_file())        
        print configuration_file(1,1) & ": " & configuration_file(1,2)
        print ""
        print "You can change the FreeBASIC compiler path."
        print ""
        input "Do you want change it (Y/N)"; answer
        print ""
        if ucase(answer) = "Y" then
          input "Insert new path: ", configuration_file(1,2)
          writes_configuration_ascii_file("clumsy_configuration.txt", _
                                          configuration_file()) 
          cls 2
        else
          cls 2
        end if

      case 66 ''F8 Help
        reads_normal_ascii_file("doc/clumsy_help.txt")
        come_back()

      case 67 ''F9 License
        reads_normal_ascii_file("doc/clumsy_license_gnu-gpl-v3.txt")
        come_back()

      case 68 ''F10
        ''not used (problems with Ubuntu terminal)
        
      case 71 ''home
        locate csrlin, 1
        
      case 72 ''up
        moves_cursor(csrlin, pos, -1, 0, code_array(), _
                     get_viewprint_rows, scrolling)

      case 73 ''page up
        ''up x 12
        for i as integer = 1 to 12
          moves_cursor(csrlin, pos, -1, 0, code_array(), _
                       get_viewprint_rows, scrolling)
        next i
        
      case 79 ''end
        locate csrlin, len(code_array(csrlin)) + 1

      case 80 ''down
        moves_cursor(csrlin, pos, 1, 0, code_array(), _
                     get_viewprint_rows, scrolling)
      
      case 81 ''page down
        ''down x 12
        for i as integer = 1 to 12
          moves_cursor(csrlin, pos, 1, 0, code_array(), _
                       get_viewprint_rows, scrolling)
        next i

      case 77 ''right
        if pos = len(code_array(csrlin + scrolling)) + 1 and _
           csrlin + scrolling < ubound (code_array) then
          ''down
          moves_cursor(csrlin, 1, 1, 0, code_array(), _
                       get_viewprint_rows, scrolling)
        else
          ''right
          moves_cursor(csrlin, pos, 0, 1, code_array(), _
                       get_viewprint_rows, scrolling)
        end if
      case 75 ''left
        if pos = 1 and csrlin + scrolling > 1 then
          ''up
          moves_cursor(csrlin, _
                       len(code_array(csrlin + scrolling - 1)) + 1, _
                       -1, 0, code_array(), _
                       get_viewprint_rows, scrolling)
        else
          'left
          moves_cursor(csrlin, pos, 0, -1, code_array(), _
                       get_viewprint_rows, scrolling)
        end if
      case 83 ''delete
        deletes_key(csrlin, pos, code_array(), _
                    get_viewprint_rows(), scrolling)
      
      case else
      ''none
      
    end select
    
  else ''ASCII extended
   
    select case key

      case 32 to 126 ''printable characters
        puts_key(get_viewprint_rows(), get_max_cols(), csrlin, pos, _
                 key, code_array(), scrolling)

      case 128 to 255 ''extended ASCII charactersOcchio!
        ''not used in console mode
        
      case 8 ''backspace
        erases_key(csrlin, pos, code_array(), _
                   get_viewprint_rows(), scrolling)
        
      case 13 ''carriage return
        new_line(get_viewprint_rows(), get_max_cols(), csrlin, pos, _
                 code_array(), scrolling)

      case 27 ''<Esc> quit
        cls 2
        print "Thanks for coding with clumsy!"
        exit do
        
      case else
        ''none

    end select

  end if

  ''to avoid unwanted or repeated characters,
  ''this loop works until the inkey buffer is empty
  while inkey <> "": wend
  
loop

sub initializes_console()

  screen 0 ''console-mode functionality

  color 15, 0 ''text white, background black
  cls 0 ''clears the entire screen

  ''footer info
  locate get_max_rows() - 1, 1
  print "<F1> New | <F2> Open | <F3> Save | <F5> Compile and Run | ";
  print "<F7>  Configuration"
  locate get_max_rows(), 1
  print " CLUMSY beta version | <F8> Help | <F9> License         | ";
  print "<Esc> Quit";

  ''sets the printable area of the console screen
  view print 1 to (get_viewprint_rows())

  color 0, 15 ''text black, background white
  cls 2 ''clear only the text viewport

end sub

''max number of rows
function get_max_rows() as integer
  return hiword(width)
end function

''max nomber of viewprint rows
function get_viewprint_rows() as integer
  return get_max_rows() - 2
end function

''max number of columns
function get_max_cols() as integer
  return loword(width)
end function

sub come_back()
  print "------------------"
  print ""
  print "Press any key to come back . . ."
  if getkey then
    initializes_console()
  else
  end if
end sub

sub clumsy_cover()

  print ""
  print ""
  print "  cccccccc  ll        uu    uu  mm    mm  ssssssss  yy    yy"
  print "  ccccccc   ll        uu    uu  mmm  mmm  sssssss   yy    yy"
  print "  cc        ll        uu    uu  mm mm mm  ss         yy  yy"
  print "  cc        ll        uu    uu  mm    mm  sssssss     yyyy"
  print "  cc        ll        uu    uu  mm    mm  ssssssss     yy"
  print "  cc        ll        uu    uu  mm    mm        ss    yy"
  print "  ccccccc   lllllll   uuuuuuuu  mm    mm   sssssss   yy"
  print "  cccccccc  llllllll  uuuuuuuu  mm    mm  ssssssss  yy"
  print ""
  print ""
  print "  CLUMSY is an elementary FreeBASIC IDE for console"
  print "                   (beta version)"
  print ""
  print ""
  print "  Copyright (C) 2020 Luca Evangelisti"
  print "  GNU General Public License version 3";
  locate 1, 1, 0
end sub
