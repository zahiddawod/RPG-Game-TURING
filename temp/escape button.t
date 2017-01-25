var key : string (1)
var times_Pressed : int := 0

loop
    if hasch then
	getch (key)
	if key = KEY_ESC then
	    locate (1, 1)
	    put "You pressed the ESCAPE key"
	    times_Pressed += 1

	    if times_Pressed mod 2 = 0 then
		cls
	    end if
	end if
    end if
end loop
