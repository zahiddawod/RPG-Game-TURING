View.Set ("graphics:640;400,nobuttonbar,position:center;truemiddle,title:RPG Game,offscreenonly")
var bg := Pic.FileNew ("ASSETS/IMG/cc/stats.bmp")
var font : array 1 .. 3 of int
var next : array 1 .. 2 of int
for i : 1 .. 3
    font (i) := Font.New ("Cambria:" + intstr (i * 12 - (i * 2)))
    if i not= 3 then
	next (i) := Pic.FileNew ("ASSETS/IMG/buttons/next-" + intstr (i) + ".bmp")
    end if
end for

var chars : string (1)
var Name : string := ""
var mx, my, mb : int
var d : int := 1
var tempd : array 1 .. 2 of int := init (0, 0)
var backSpace : boolean := false

loop
    Mouse.Where (mx, my, mb)
    Pic.Draw (bg, -258, -410, picMerge)
    Font.Draw ("Character Name: ", 40, 320, font (3), black)

    if Name = "" then
	tempd (1) += 1
	if tempd (1) = 1 then
	    for i : 1 .. 2
		next (i) := Pic.FileNew ("ASSETS/IMG/buttons/next-Locked.bmp")
	    end for
	end if
	tempd (2) := 0
    else
	tempd (2) += 1
	if tempd (2) = 1 then
	    for i : 1 .. 2
		next (i) := Pic.FileNew ("ASSETS/IMG/buttons/next-" + intstr (i) + ".bmp")
	    end for
	end if
	tempd (1) := 0
    end if

    if hasch then
	getch (chars)
	for i : 1 .. 27
	    if chars = chr (96 + i) then
		Name += chr (96 + i)
	    elsif chars = chr (65 + i) then
		Name += chr (65 + i)
	    end if
	end for
	if chars = " " then
	    Name += " "
	elsif chars = chr (8) then
	    backSpace := true
	end if
    end if

    if mb = 1 and mx >= maxx - 40 and my >= 20 and mx <= maxx - 22 and my <= 42 then
	exit
    elsif mb = 0 and mx >= maxx - 40 and my >= 20 and mx <= maxx - 22 and my <= 42 then
	d := 2
    else
	d := 1
    end if

    if mb = 1 and mx >= 20 and my >= 20 and mx <= 60 and my <= 40 or backSpace = true then
	Name := ""
	backSpace := false
    end if

    Font.Draw ("Reset", 20, 20, font (1), black)
    Pic.Draw (next (d), maxx - 40, 20, picMerge)
    Font.Draw (Name, 40, 200, font (2), black)
    View.Update
end loop
