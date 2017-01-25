type PlayerTempInfo :
    record
	Name : string
	ability : array 1 .. 3 of int %// 1 = DEXTERITY(Rogue), 2 = STRENGTH(Knight), 3 = INTELLEGENCE
	Class : string
    end record

var Character : PlayerTempInfo
var tmp : int := 1

proc CharacterCreation
    setscreen ("graphics:900;860,nobuttonbar,position:center;truemiddle,title:RPG Game,offscreenonly")
    var creation_menu : int := Pic.FileNew ("ASSETS/IMG/cc/classchoice.bmp")
    var fL : array 1 .. 3 of int := init (160, 440, 720)
    var mx, my, mb : int
    var tempNUM : int := 0
    var bleft := Pic.FileNew ("ASSETS/IMG/buttons/b-left.bmp")
    var bright : array 1 .. 2 of int
    for i : 1 .. 2
	bright (i) := Pic.FileNew ("ASSETS/IMG/buttons/next-" + intstr (i) + ".bmp")
    end for

    var exitCC : boolean := false
    var classes : array 1 .. 3 of string := init ("rogue", "warrior", "mage")

    Pic.Draw (creation_menu, 0, 0, picMerge)

    var cT : array 1 .. 3 of int
    var check : array 1 .. 3 of int
    for i : 1 .. 3
	check (i) := Pic.FileNew ("ASSETS/IMG/buttons/check-" + intstr (i) + ".bmp")
	cT (i) := Pic.FileNew ("ASSETS/IMG/cc/text_" + intstr (i) + ".bmp")
	Pic.Draw (check (1), fL (i), 190, picMerge)
    end for
    var tcT : int := cT (1)
    var tmpimg : int := check (1)

    for i : 1 .. 3
	Character.ability (i) := 3
    end for

    loop
	Mouse.Where (mx, my, mb)
	Pic.Draw (creation_menu, 0, 0, picMerge)
	for i : 1 .. 3
	    Pic.Draw (check (1), fL (i), 190, picMerge)
	end for
	Pic.Draw (tmpimg, fL (tmp), 190, picMerge)
	Pic.Draw (tcT, 100, 100, picMerge)
	Pic.Draw (bright (1), 840, 20, picMerge)

	for i : 1 .. 3
	    if mb = 1 and mx >= fL (i) and my >= 190 and mx <= fL (i) + 16 and my <= 206 then
		tmp := i
	    end if
	    if tmp = i then
		tmpimg := check (3)
		tcT := cT (i)
	    end if
	end for
	if mb = 1 and mx >= 840 and my >= 20 and mx <= 870 and my <= 50 then
	    exit
	elsif mb = 0 and mx >= 840 and my >= 20 and mx < 870 and my <= 50 then
	    Pic.Draw (bright (2), 840, 20, picMerge)
	end if
	View.Update
    end loop

    %--------------------------------------------------------------------STATS----------------------------------------------------------------------%

    Character.Class := classes (tmp)
    var statFont := Font.New ("Cambria:24")

    var perkIMG : array 1 .. 3 of int
    var spClass : array 1 .. 3 of int
    for i : 1 .. 3
	perkIMG (i) := Pic.FileNew ("ASSETS/IMG/cc/class_perk_" + intstr (i) + ".bmp")
	spClass (i) := Pic.FileNew ("ASSETS/IMG/cc/class_sprite_" + intstr (i) + ".bmp")
    end for

    var minus : array 1 .. 2 of int
    var plus : array 1 .. 2 of int

    for i : 1 .. 2
	minus (i) := Pic.FileNew ("ASSETS/IMG/buttons/minus-" + intstr (i) + ".bmp")
	plus (i) := Pic.FileNew ("ASSETS/IMG/buttons/plus-" + intstr (i) + ".bmp")
    end for

    Character.ability (tmp) += 2

    var stat_menu := Pic.FileNew ("ASSETS/IMG/cc/stats.bmp")

    var key : string (1)
    var maxpoints : int := 0
    for i : 1 .. 2
	bright (i) := Pic.FileNew ("ASSETS/IMG/buttons/next-Locked.bmp")
    end for

    Mouse.ButtonChoose ("multibutton")
    loop
	Mouse.Where (mx, my, mb)
	Pic.Draw (stat_menu, 0, 0, picMerge)
	Pic.Draw (tcT, 600, 820, picMerge)
	Pic.Draw (spClass (tmp), 450, 275, picMerge)
	Pic.Draw (perkIMG (tmp), 40, 20, picMerge)
	Pic.Draw (bleft, 10, 20, picMerge)
	Pic.Draw (bright (1), 840, 20, picMerge)
	Font.Draw ("Points Left: " + intstr (7 - maxpoints), 50, 800, statFont, black)

	for i : 1 .. 3
	    Font.Draw (intstr (Character.ability (i)), 100, maxy - (i * 200), statFont, black)
	    Pic.Draw (plus (1), 140, maxy - (i * 200), picMerge)
	    Pic.Draw (minus (1), 60, maxy - (i * 200), picMerge)
	    if mb = 1 and mx >= 140 and my >= maxy - (i * 200) and mx <= 162 and my <= maxy - (i * 178) and maxpoints not= 7 then
		Character.ability (i) += 1
		maxpoints += 1
	    elsif mb = 0 and mx >= 140 and my >= maxy - (i * 200) and mx <= 162 and my <= maxy - (i * 178) then
		Pic.Draw (plus (2), 140, maxy - (i * 200), picMerge)
	    end if
	    if mb = 1 and mx >= 60 and my >= maxy - (i * 200) and mx <= 82 and my <= maxy - (i * 178) and maxpoints not= 0 then
		Character.ability (i) -= 1
		maxpoints -= 1
	    elsif mb = 0 and mx >= 60 and my >= maxy - (i * 200) and mx <= 82 and my <= maxy - (i * 178) then
		Pic.Draw (minus (2), 60, maxy - (i * 200), picMerge)
	    end if
	end for
	if mb = 1 and mx >= 10 and my >= 20 and mx <= 40 and my <= 50 then
	    for i : 1 .. 3
		Character.ability (i) := 3
	    end for
	    for i : 1 .. 2
		bright (i) := Pic.FileNew ("ASSETS/IMG/buttons/next-" + intstr (i) + ".bmp")
	    end for
	    tempNUM := 0
	    loop
		Mouse.Where (mx, my, mb)
		Pic.Draw (creation_menu, 0, 0, picMerge)
		for i : 1 .. 3
		    Pic.Draw (check (1), fL (i), 190, picMerge)
		end for
		Pic.Draw (tmpimg, fL (tmp), 190, picMerge)
		Pic.Draw (tcT, 100, 100, picMerge)
		Pic.Draw (bright (1), 840, 20, picMerge)

		for i : 1 .. 3
		    if mb = 1 and mx >= fL (i) and my >= 190 and mx <= fL (i) + 16 and my <= 206 then
			tmp := i
		    end if
		    if tmp = i then
			tmpimg := check (3)
			tcT := cT (i)
		    end if
		end for
		if mb = 1 and mx >= 840 and my >= 20 and mx <= 870 and my <= 50 then
		    exit
		elsif mb = 0 and mx >= 840 and my >= 20 and mx < 870 and my <= 50 then
		    Pic.Draw (bright (2), 840, 20, picMerge)
		end if
		View.Update
	    end loop
	    Character.ability (tmp) += 2
	    maxpoints := 0
	end if

	if maxpoints = 7 then
	    tempNUM += 1
	    if tempNUM = 1 then
		for i : 1 .. 2
		    bright (i) := Pic.FileNew ("ASSETS/IMG/buttons/next-" + intstr (i) + ".bmp")
		end for
	    end if

	    if mb = 1 and mx >= 840 and my >= 20 and mx <= 870 and my <= 50 then
		exitCC := true
	    elsif mb = 0 and mx >= 840 and my >= 20 and mx < 870 and my <= 50 then
		Pic.Draw (bright (2), 840, 20, picMerge)
	    end if
	    tempNUM := 0
	else
	    tempNUM += 1
	    if tempNUM = 1 then
		for i : 1 .. 2
		    bright (i) := Pic.FileNew ("ASSETS/IMG/buttons/next-Locked.bmp")
		end for
	    end if
	end if

	if exitCC = true then
	    colorback (black)
	    cls
	    View.Update
	    delay (1000)
	    exit
	end if

	View.Update
	cls
	delay (50)
    end loop

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
		elsif chars = chr (64 + i) then
		    Name += chr (64 + i)
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
    Character.Name := Name
end CharacterCreation
