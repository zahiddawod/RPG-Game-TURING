setscreen ("graphics:960;800,nobuttonbar,position:center;truemiddle,title:RPG Game")
var getCommand : string

proc Command_Prompt
    var blankStr : string := ""
    var Loc : int := 20
    var count : int := 1

    %Draw.FillBox (0, maxy, maxx - (maxx div 4), maxy - (maxy div 4), black)
    for x : 1 .. 82
	locatexy (x, maxy - (maxy div 4) + 10)
	put blankStr ..
	blankStr += " "
    end for

    for i : 1 .. 10
	var storeCmd : array 1 .. count of string
	storeCmd (count) := "Type 'help' for a list of commands"
	color (white)
	colorback (black)

	locatexy (10, maxy - (maxy div 4) + Loc + (count * 20))
	put storeCmd (count) ..
	i
	locatexy (10, maxy - (maxy div 4) + 100)
	put storeCmd (count) ..
	

	color (black)
	colorback (white)
	locatexy (10, maxy - (maxy div 4) + 10)
	get getCommand : *
	if getCommand = "" then
	    getCommand := ">"
	else
	    getCommand := "> " + getCommand
	end if
	count += 1
	storeCmd (i) := getCommand

	for x : 1 .. 80
	    locatexy (x, maxy - (maxy div 4) + 10)
	    put blankStr ..
	end for
    end for
end Command_Prompt

Command_Prompt
