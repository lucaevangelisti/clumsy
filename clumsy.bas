''project: clumsy | pre-alpha version
''description: text editor for console 
''author: Luca Evangelisti
''last update: 3th February 2020
''GitHub: https://github.com/lucaevangelisti/clumsy
''license: https://github.com/lucaevangelisti/clumsy/blob/master/LICENSE

dim as uinteger max_rows, max_cols

screen 0 ''console-mode functionality

max_rows = hiword(width) ''max number of rows
max_cols = loword(width) ''max number of columns

color 7, 0 ''text grey, background black
cls 0 ''clears the entire screen

''footer info
locate max_rows, 1
print "clumsy is a silly text editor for console"; _
      " | pre-alpha version" _
      " | ^H for Help";

''sets the printable area of the console screen
view print 1 to (max_rows - 1)

color 0, 7 ''text black, background grey
cls 2 ''clear only the text viewport

''text
print "Hello, world!";

sleep
