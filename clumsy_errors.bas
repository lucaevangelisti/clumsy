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

declare function check_error(error_code as long) as string

function check_error(error_code as long) as string

  dim e as string
  
  select case error_code
    case 0
      e = "no error"
    case 1
      e = "Illegal function call"
    case 2
      e = "File not found"
    case 3
      e = "File I/O error"
    case 4
      e = "Out of memory"
    case 5
      e = "Illegal resume"
    case 6
      e = "Out of bounds array access"
    case 7
      e = "Null Pointer Access"
    case 8
      e = "No privileges"
    case 9
      e = "Interrupted signal"
    case 10
      e = "Illegal instruction signal"
    case 11
      e = "Floating point error signal"
    case 12
      e = "Segmentation violation signal"
    case 13
      e = "Termination request signal"
    case 14
      e = "Abnormal termination signal"
    case 15
      e = "Quit request signal"
    case 16
      e = "Return without gosub"
    case 17
      e = "End of file"
  end select

  return e
  
end function
