var lose, win : boolean
lose := false
win := false
var fBx : array 1 .. 4 of int
var fBy : array 1 .. 4 of int
var spF : array 1 .. 4 of int
var countTx : int := 0
var charB : int
var cl : string

proc FrameBox
    Draw.FillBox (520, 200, 540, 50, black)
    Draw.FillBox (780, 200, 800, 50, black)
    Draw.FillBox (520, 200, 800, 180, black)
    Draw.FillBox (520, 60, 800, 40, black)
end FrameBox

proc projectiles
    for i : 1 .. 4
	fBx (i) := 520
	fBy (i) := Rand.Int (60, 180)
	spF (i) := Rand.Int (12, 16)
    end for
end projectiles

proc BS
    cls
    setscreen ("graphics:960;800,nobuttonbar,position:center;truemiddle,title:RPG Game: Battle,offscreenonly")
    var dragon_L : array 1 .. 10 of int
    for i : 1 .. 10
	dragon_L (i) := Pic.FileNew ("ASSETS/IMG/sprites/dragon/dragon_boss_" + intstr (i) + ".bmp")
    end for
    var aB_I := Pic.FileNew ("ASSETS/IMG/sprites/attackBar.bmp")
    var attackBar := Pic.Scale (aB_I, 520, 150)
    var P : array 1 .. 2 of int := init (10, 10) %// 1=HP,2=MP
    var minP : array 1 .. 2 of int := init (540, 690) %// 1=HP,2=MP
    var mx, my, mb : int
    var DHP : int := 1000

    var font1 := Font.New ("Cambria:18")
    var font2 := Font.New ("Cambria:28")
    var buttons : array 1 .. 4 of string := init ("FIGHT", "ACT", "ITEM", "MERCY")
    var bLoc : array 1 .. 4 of int := init (50, 140, 215, 300)
    var minX : array 1 .. 4 of int := init (40, 125, 200, 290)
    var maxX : array 1 .. 4 of int := init (125, 200, 285, 385)
    var bBool : array 1 .. 4 of boolean := init (false, false, false, false)
    var stickPosX : int := 0
    var increm : int := 20
    var key : string (1)
    var Damage : int := 100 %// Caculated based on strength

    var sDIN : array 1 .. 10 of boolean := init (false, false, false, false, false, false, false, false, false, false)
    var sDFlee : array 1 .. 2 of string := init ("Dragon does not let you leave!", "Darn! You almost got away")
    var sDSpare : array 1 .. 2 of string := init ("You attempt to spare the dragon ...", "*Dragon Laughs*")
    var randT : int
    var sD : boolean := false
    var sD1 : boolean := false
    var sD2 : boolean := false
    var sD3 : boolean := false
    var sD4 : boolean := false
    var tempInt : int := 0
    var tempInt2 : int := 0
    var initiateC : boolean := false
    var count4 : int := 0
    var healthPot : int := 1

    loop
	for i : 1 .. 10
	    Mouse.Where (mx, my, mb)
	    for b2 : 1 .. 4
		if mb = 0 and mx >= minX (b2) and my >= 10 and mx <= maxX (b2) and my <= 45 then
		    Draw.FillBox (minX (b2), 45, maxX (b2), 10, 54)
		elsif mb = 1 and mx >= minX (b2) and my >= 10 and mx <= maxX (b2) and my <= 45 then
		    bBool (b2) := true
		end if
	    end for

	    Pic.Draw (dragon_L (i), 50, 220, picMerge)
	    Pic.Draw (charB, 860, 50, picMerge)
	    FrameBox
	    Draw.FillBox (minP (1), 10, minP (1) + (P (1) * 10), 30, brightred)
	    locatexy (maxx - 440, 16)
	    put "HP:" ..
	    Draw.FillBox (minP (2), 10, minP (2) + (P (2) * 10), 30, brightblue)
	    locatexy (maxx - 296, 16)
	    put "MP:" ..
	    Draw.FillBox (0, 780, DHP, 800, 4)
	    for b : 1 .. 4
		Font.Draw (buttons (b), bLoc (b), 20, font1, black)
	    end for

	    if bBool (1) = true then
		sD2 := false
		sD4 := false
		stickPosX := Rand.Int (20, 480)
		var exitA : boolean := false
		loop
		    for it : 1 .. 10
			Pic.Draw (attackBar, 0, 50, picMerge)
			Pic.Draw (dragon_L (it), 50, 220, picMerge)
			Pic.Draw (charB, 860, 50, picMerge)
			FrameBox
			Draw.FillBox (minP (1), 10, minP (1) + (P (1) * 10), 30, brightred)
			locatexy (maxx - 440, 16)
			put "HP:" ..
			Draw.FillBox (minP (2), 10, minP (2) + (P (2) * 10), 30, brightblue)
			locatexy (maxx - 296, 16)
			put "MP:" ..
			Draw.FillBox (0, 780, DHP, 800, 4) %// Dragon HP
			for b : 1 .. 4
			    Font.Draw (buttons (b), bLoc (b), 20, font1, black)
			end for
			stickPosX += increm
			Draw.FillBox (stickPosX, 200, stickPosX + 20, 50, 54)
			if stickPosX >= 490 then
			    increm := -20
			elsif stickPosX <= 0 then
			    increm := 20
			end if

			if hasch then
			    getch (key)
			    if key = " " then
				if stickPosX >= 235 and stickPosX <= 290 then
				    Damage := 100
				    DHP -= Damage
				else
				    Damage := 0
				end if
				sD := true
				exitA := true
				exit
			    end if
			end if

			delay (50)
			View.Update
			cls
		    end for
		    exit when exitA = true
		end loop
		bBool (1) := false
	    elsif bBool (2) = true then
		sD3 := false
		sD4 := false
		sD2 := true
		bBool (2) := false
	    elsif bBool (3) = true then
		sD2 := false
		sD4 := false
		sD3 := true
		bBool (3) := false
	    elsif bBool (4) = true then
		sD3 := false
		sD2 := false
		count4 += 1
		if count4 mod 2 = 0 then
		    sD4 := false
		    bBool (4) := false
		else
		    sD4 := true
		    bBool (4) := false
		end if
	    end if

	    if sD = true then
		tempInt += 1
		Font.Draw ("- " + intstr (Damage), 800, 750, font2, red)
		if Damage = 0 then
		    Font.Draw ("MISS!", 700, 420, font2, 4)
		end if
		Font.Draw ("SURVIVE!", 585, 120, font2, 4)
		View.Update
		if tempInt = 15 then
		    tempInt := 0
		    sD := false
		    initiateC := true
		end if
	    end if

	    if sD1 = true then
		tempInt += 1
		Font.Draw ("SURVIVE!", 585, 120, font2, 4)
		View.Update
		if tempInt = 15 then
		    tempInt := 0
		    sD1 := false
		    initiateC := true
		end if
	    end if

	    if sD2 = true then
		if mb = 0 and mx >= 30 and my >= 130 and mx <= 170 and my <= 165 then
		    Draw.FillBox (30, 130, 170, 165, 54)
		elsif mb = 0 and mx >= 30 and my >= 70 and mx <= 170 and my <= 105 then
		    Draw.FillBox (30, 70, 170, 105, 54)
		end if
		if mb = 1 and mx >= 30 and my >= 130 and mx <= 170 and my <= 165 then
		    sDIN (3) := true
		elsif mb = 1 and mx >= 30 and my >= 70 and mx <= 170 and my <= 105 then
		    sDIN (4) := true
		end if
		Font.Draw ("Enemy Stats", 40, 140, font1, black)
		Font.Draw ("Compliment", 40, 80, font1, black)
	    end if

	    if sD3 = true then
		if mb = 0 and mx >= 30 and my >= 130 and mx <= 195 and my <= 165 then
		    Draw.FillBox (30, 130, 195, 165, 54)
		elsif mb = 1 and mx >= 30 and my >= 130 and mx <= 195 and my <= 165 and healthPot > 0 then
		    P (1) := 10
		    healthPot -= 1
		    sD3 := false
		end if
		if cl = "mage" then
		    if mb = 0 and mx >= 30 and my >= 70 and mx <= 185 and my <= 105 then
			Draw.FillBox (30, 70, 195, 105, 54)
		    elsif mb = 1 and mx >= 30 and my >= 70 and mx <= 185 and my <= 105 and P (2) > 0 then
			tempInt2 += 1
			P (2) -= 5
			P (1) := 10
			sD3 := false
		    end if
		    Font.Draw ("Regeneration", 40, 80, font1, black)
		end if
		Font.Draw ("Health Pot (" + intstr (healthPot) + ")", 40, 140, font1, black)
	    end if

	    if sD4 = true then
		if mb = 0 and mx >= 30 and my >= 130 and mx <= 105 and my <= 165 then
		    Draw.FillBox (30, 130, 105, 165, 54)
		elsif mb = 0 and mx >= 30 and my >= 70 and mx <= 115 and my <= 105 then
		    Draw.FillBox (30, 70, 115, 105, 54)
		end if
		if mb = 1 and mx >= 30 and my >= 130 and mx <= 105 and my <= 165 then
		    sDIN (1) := true
		    randT := Rand.Int (1, 2)
		elsif mb = 1 and mx >= 30 and my >= 70 and mx <= 115 and my <= 105 then
		    sDIN (2) := true
		    randT := Rand.Int (1, 2)
		end if
		Font.Draw ("SPARE", 40, 80, font1, black)
		Font.Draw ("FLEE", 40, 140, font1, black)
	    end if

	    if sDIN (1) = true then
		tempInt2 += 1
		Font.Draw (sDFlee (randT), 600, 450, font1, 4)
		View.Update
		if tempInt2 = 15 then
		    tempInt2 := 0
		    sDIN (1) := false
		    sD4 := false
		    sD1 := true
		end if
	    end if

	    if sDIN (2) = true then
		tempInt2 += 1
		Font.Draw (sDSpare (randT), 580, 450, font1, 4)
		View.Update
		if tempInt2 = 15 then
		    tempInt2 := 0
		    sDIN (2) := false
		    sD4 := false
		    sD1 := true
		end if
	    end if

	    if sDIN (3) = true then
		tempInt2 += 1
		Font.Draw ("Dragon DMG: OVER 9000!", 580, 450, font1, 4)
		View.Update
		if tempInt2 = 15 then
		    tempInt2 := 0
		    sDIN (3) := false
		    sD2 := false
		end if
	    end if

	    if sDIN (4) = true then
		tempInt2 += 1
		Font.Draw ("*Dragon Blushes*", 580, 450, font1, 4)
		View.Update
		if tempInt2 = 15 then
		    tempInt2 := 0
		    sDIN (4) := false
		    sD2 := false
		end if
	    end if
	    if initiateC = true then
		var xLB, yLB : int
		xLB := maxx - 200
		yLB := 80
		var chars : array char of boolean
		projectiles
		var exitFL : boolean := false
		countTx := 0
		loop
		    for it : 1 .. 10
			Font.Draw ("Use ARROW Keys!", 560, 210, font1, 4)
			Pic.Draw (dragon_L (it), 50, 220, picMerge)
			Pic.Draw (charB, 860, 50, picMerge)
			FrameBox
			Draw.FillBox (minP (1), 10, minP (1) + (P (1) * 10), 30, brightred)
			locatexy (maxx - 440, 16)
			put "HP:" ..
			Draw.FillBox (minP (2), 10, minP (2) + (P (2) * 10), 30, brightblue)
			locatexy (maxx - 296, 16)
			put "MP:" ..
			Draw.FillBox (0, 780, DHP, 800, 4)
			for b : 1 .. 4
			    Font.Draw (buttons (b), bLoc (b), 20, font1, black)
			end for

			Input.KeyDown (chars)
			if chars (KEY_UP_ARROW) and chars (KEY_RIGHT_ARROW) and yLB < 170 and xLB < 765 then
			    xLB += 5
			    yLB += 5
			elsif chars (KEY_UP_ARROW) and chars (KEY_LEFT_ARROW) and yLB < 170 and xLB > 540 then
			    xLB -= 5
			    yLB += 5
			elsif chars (KEY_DOWN_ARROW) and chars (KEY_RIGHT_ARROW) and yLB > 60 and xLB < 765 then
			    yLB -= 5
			    xLB += 5
			elsif chars (KEY_DOWN_ARROW) and chars (KEY_LEFT_ARROW) and yLB > 60 and xLB > 540 then
			    yLB -= 5
			    xLB -= 5
			elsif chars (KEY_UP_ARROW) and yLB < 170 then
			    yLB += 5
			elsif chars (KEY_DOWN_ARROW) and yLB > 60 then
			    yLB -= 5
			elsif chars (KEY_LEFT_ARROW) and xLB > 540 then
			    xLB -= 5
			elsif chars (KEY_RIGHT_ARROW) and xLB < 765 then
			    xLB += 5
			end if

			Draw.FillBox (xLB, yLB, xLB + 10, yLB + 10, 54)

			for bs : 1 .. 4
			    if fBx (bs) < 780 then
				fBx (bs) += spF (bs)
				Draw.FillOval (fBx (bs), fBy (bs), 8, 4, 4)
				if fBx (bs) >= xLB - 6 and fBy (bs) >= yLB - 6 and fBx (bs) <= xLB + 6 and fBy (bs) <= yLB + 6 then
				    P (1) -= 1
				end if
			    else
				if countTx not= 3 then
				    countTx += 1
				    projectiles
				else
				    exitFL := true
				    exit
				end if
			    end if
			end for

			if P (1) < 0 then
			    P (1) := 0
			    exitFL := true
			    lose := true
			    exit
			end if

			delay (50)
			View.Update
			cls
		    end for
		    exit when exitFL = true
		end loop
		initiateC := false
	    end if

	    %P (1) -= 1 %// Used to debug death
	    if P (1) < 0 then
		P (1) := 0
		lose := true
		exit
	    end if

	    if DHP <= 0 then
		win := true
		exit
	    end if

	    if lose = true then
		exit
	    elsif win = true then
		exit
	    end if

	    delay (100)
	    View.Update
	    cls
	end for
	if lose = true then
	    exit
	elsif win = true then
	    exit
	end if
    end loop
end BS
