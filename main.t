include "Modules/CC.t"
include "Modules/BattleSystem.t"

% //MUSIC// &

setscreen ("nocursor")
process music_main
    Music.PlayFile ("ASSETS/Audio/music/Main.mp3")
end music_main

process play_music
    Music.PlayFile ("ASSETS/Audio/music/villagemusic-1.mp3")
end play_music

process play_autumn_voyage
    Music.PlayFile ("ASSETS/Audio/music/Autumn Voyage.mp3")
end play_autumn_voyage

process play_parade
    Music.PlayFile ("ASSETS/Audio/music/Parade.mp3")
end play_parade

process play_dungeon_music_1
    Music.PlayFile ("ASSETS/Audio/music/Scape Cave.mp3")
end play_dungeon_music_1

process battle_dragon
    Music.PlayFile ("ASSETS/Audio/music/Dragon Battle.mp3")
end battle_dragon

% //PUBLIC VARIABLES// %

var winID1 := Window.Open ("graphics:1190;670,nobuttonbar,position:center;truemiddle,title:RPG Game")

Window.Select (winID1)
colorback (black)
cls
Window.SetActive (winID1)

var file_Saves : string := "Saves/Saves.txt"
var temp_Str : string
var fSe : int
var tempNUM2 : int := 0
var font : array 1 .. 3 of int
for i : 1 .. 3
    font (i) := Font.New ("Cambria:" + intstr (i * 12 - (i * 2)))
end for

var resume : boolean := false
var let, num : int := 3
var letStr : array 1 .. 8 of string
for i : 1 .. 8
    letStr (i) := chr (64 + i)
end for
var xLoc, yLoc : int := maxx div 2
var up, left, down, right : int
up := 1
left := 2
down := 3
right := 4
var dir : int := down

var temp : int := 1
var a : int := 1
var cursor := Pic.FileNew ("ASSETS/img/cursor.bmp")
var note := Pic.FileNew ("ASSETS/IMG/sprites/note.bmp")
var newgame : boolean := false

type PlayerInfo :
    record
	Name : string
	Level : int
	HP : int
	MP : int
	Sprite : array 1 .. 4, 1 .. 3 of int
	ability : array 1 .. 3 of int %// 1 = DEXTERITY(Rogue), 2 = STRENGTH(Knight), 3 = INTELLEGENCE
	Location : array 1 .. 4 of int %// 1 = X, 2 = Y, 3 = Letter (Left, Right), 4 = Number (Up, Down)
	Class : string
    end record

var player : PlayerInfo
var file_Name : string
var numl : int := 20
var saveSuccessful : boolean := false
var LCO : int := 0
var STEXT : boolean := false
var tempNumFST : int := 0
var fileLoad : string
var f1l, f2l : int
var saveL : array 1 .. 10 of string
var countl : int := 0
var linel : string
var bee : boolean := false
open : f1l, "Saves/Saves.txt", get
loop
    countl += 1
    get : f1l, linel
    saveL (countl) := linel
    if linel = "0" then
	STEXT := true
	bee := false
	exit
    else
	bee := true
    end if
    exit when eof (f1l) = true
end loop
close : f1l

% //PROCEDURES// %

proc enableCursor
    if Sys.Exec (("\"scripts\\enableCursor.bat\"")) = true then
	put skip
    else
	colorback (white)
	cls
	color (black)
	loop
	    locate (1, 1)
	    put "Uh oh: An Error Has Occured."
	    View.Update
	end loop
    end if
end enableCursor

proc LoadSave
    tempNumFST := 0
    var mx, my, mb : int
    var d2 : int
    var name, classs : string
    var level, hp, mp, dex, str, intl, locx, locy, loclet, locnum : int


    if bee = true then
	colorback (white)
	cls
	color (black)
	loop
	    Mouse.Where (mx, my, mb)
	    Draw.Line (maxx, 580, 0, 580, black)

	    for i : 2 .. countl
		if mb = 1 and mx >= 0 and my >= 640 - (60 * i) and mx <= maxx and my <= 700 - (60 * i) then
		    fileLoad := saveL (i)
		    open : d2, "Saves/" + fileLoad + ".txt", get
		    get : d2, name
		    get : d2, classs
		    get : d2, level
		    get : d2, hp
		    get : d2, mp
		    get : d2, dex
		    get : d2, str
		    get : d2, intl
		    get : d2, locx
		    get : d2, locy
		    get : d2, loclet
		    get : d2, locnum
		    close : d2
		    player.Name := name
		    player.Class := classs
		    player.Level := level
		    player.HP := hp
		    player.MP := mp
		    player.ability (1) := dex
		    player.ability (2) := str
		    player.ability (3) := intl
		    player.Location (1) := locx
		    player.Location (2) := locy
		    player.Location (3) := loclet
		    player.Location (4) := locnum
		    bee := false
		    exit
		elsif mb = 0 and mx >= 0 and my >= 640 - (60 * i) and mx <= maxx and my <= 700 - (60 * i) then
		    Draw.FillBox (maxx, 640 - (60 * i), 0, 700 - (60 * i), 54)
		end if
		Font.Draw (saveL (i), maxx div 2 - (20 * (length (saveL (i)) div 2)), 600 - (60 * (i - 1)), font (3), black)
		Draw.Line (maxx, 640 - (60 * i), 0, 640 - (60 * i), black)
	    end for

	    exit when bee = false

	    Pic.Draw (cursor, mx, my - 28, picMerge)
	    View.Update
	    cls
	end loop
    end if
end LoadSave

proc MainMenu
    setscreen ("graphics:1190;670,nobuttonbar,position:center;truemiddle,title:RPG Game,offscreenonly")
    var mx, my, mb : int
    var picNum, newpicNum : int := 1
    newpicNum := 100
    var play_Music : int := 1
    var mainMenu : array 1 .. 300 of int
    var tempINT : int := 0

    var font1 : int := Font.New ("serif:48")
    var secondx : real := (maxx div 2 - 100)
    var tempT : array 1 .. 4 of int := init (1, 1, 1, 1)
    var boolButton : array 1 .. 4 of boolean := init (false, false, false, false)
    var disableB1, disableB3 : boolean := false
    var minF, maxF, newminF, newmaxF : int := 1
    maxF := 100
    newmaxF := 100

    %// Disables Windows default cursor and makes sure it only does it once (Runs External Program Once)
    tempINT += 1
    if tempINT = 1 then     %// Makes sure it runs the .exe once
	if Sys.Exec (("\"scripts\\noCursor.exe\"")) = true then
	    put skip
	end if
	tempINT := 0
    end if

    %// Load Frames 1 to 150 for Main Menu Animation
    for i : minF .. maxF
	Mouse.Where (mx, my, mb)     %// Grab mouse info to display custom cursor
	mainMenu (i) := Pic.FileNew ("ASSETS/MainMenu/bgLayer " + intstr (i) + ".jpg")     %// Loads frames into turing
	secondx += 200 / maxF     %// Displays the percentage at which the loading is currently at (Loading Bar)
	drawfillbox (maxx div 2 - 100, maxy div 2 - 10, floor (secondx), maxy div 2 + 10, 4)     %// Draws Loading Box
	locatexy (maxx div 2 - 40, maxy div 2 - 30)
	color (white)
	put "LOADING ", round (((secondx - (maxx div 2 - 100)) / 200) * 100), "%"
	drawbox (maxx div 2 - 100, maxy div 2 - 10, maxx div 2 + 100, maxy div 2 + 10, 4)     %// Loading Bar Red Outline
	Pic.Draw (cursor, mx, my - 28, picMerge)     %// Replaces default cursor
	View.Update     %// Removes flickering and updates screen every loop
	cls     %// Clears screen so it doesn't overflow and lag
    end for

    var oldPic : array 1 .. 4, 1 .. 3 of int     %// Used to scale buttons down because I was too lazy to use photoshop again
    var button : array 1 .. 4, 1 .. 3 of int
    var musicbtn := Pic.FileNew ("ASSETS/IMG/buttons/Updated/music.jpg")

    for b : 1 .. 4     %// 1 = Resume, 2 = New, 3 = Load, 4 = Quit
	for t : 1 .. 3     %// 1 = Defualt, 2 = Hover, 3 = Clicked
	    oldPic (b, t) := Pic.FileNew ("ASSETS/IMG/buttons/Updated/" + intstr (b) + "-" + intstr (t) + ".bmp")
	    button (b, t) := Pic.Scale (oldPic (b, t), 220, 40)
	end for
    end for

    %// Checks if there is a Save File
    open : fSe, file_Saves, get
    get : fSe, temp_Str
    if temp_Str = "0" then
	for i : 1 .. 3
	    oldPic (1, i) := Pic.FileNew ("ASSETS/IMG/buttons/Updated/1-Locked.bmp")
	    button (1, i) := Pic.Scale (oldPic (1, i), 220, 40)
	    oldPic (3, i) := Pic.FileNew ("ASSETS/IMG/buttons/Updated/3-Locked.bmp")
	    button (3, i) := Pic.Scale (oldPic (3, i), 220, 40)
	end for
	disableB1 := true     %// If there isn't then disable resume button
	disableB3 := true     %// Also disable Load button (Because there is nothing to load)
    end if
    close : fSe

    fork music_main     %// Begin main menu music ..
    loop
	Mouse.Where (mx, my, mb)     %// Detect Mouse Location (x, y) and Click Detection

	if newpicNum not= newmaxF then     %// Whenever the newpicNum set does not equal 300
	    picNum += 1     %// The next picture that will be displayed in the current set (1 to 150, 151 to 300)
	    newpicNum += 1     %// As Frames from 1 to 150 are being displayed (picNum) the next set is currently being generated. (151 to 300)
	    mainMenu (newpicNum) := Pic.FileNew ("ASSETS/MainMenu/bgLayer " + intstr (newpicNum) + ".jpg")     %// Creates the next set of Frames (151 to 300)
	elsif picNum not= newmaxF then
	    picNum += 1
	    delay (30)
	else
	    picNum := 1     %// Restart Background Animation Loop
	end if

	Pic.Draw (mainMenu (picNum), 0, 0, picCopy)     %// Draws Main Menu Background
	Pic.Draw (musicbtn, 1120, 20, picMerge)     %// Draws Music Button
	if mb = 1 and mx >= 1120 and my >= 20 and mx <= 1174 and my <= 74 then
	    delay (100)
	    musicbtn := Pic.FileNew ("ASSETS/IMG/buttons/Updated/nomusic.jpg")
	    Music.PlayFileStop
	    play_Music += 1
	    if play_Music mod 2 = 0 then
		musicbtn := Pic.FileNew ("ASSETS/IMG/buttons/Updated/music.jpg")
		fork music_main
	    end if
	end if

	if STEXT = true then
	    Font.Draw ("There Are Currently No Save Files.", maxx div 2 - 200, maxy div 2, font (2), black)
	    View.Update
	    tempNumFST += 1
	    if tempNumFST > 30 then
		STEXT := false
	    end if
	end if

	%// Draws Buttons
	for b : 1 .. 4
	    Pic.Draw (button (b, tempT (b)), 20, 260 - (b * 60), picMerge)
	    if mb = 0 and mx >= 20 and my >= 260 - (b * 60) and mx <= 220 and my <= 300 - (b * 59) then
		tempT (b) := 2
	    elsif mb = 1 and mx >= 20 and my >= 260 - (b * 60) and mx <= 220 and my <= 300 - (b * 59) then
		tempT (b) := 3
		tempINT += 1
		boolButton (b) := true
	    else
		tempT (b) := 1
	    end if
	end for

	%// Decides what to do if a certain button is pressed
	if boolButton (1) = true and disableB1 = false then
	    resume := true
	    exit
	elsif boolButton (2) = true then
	    cls
	    colorback (black)
	    Music.PlayFileStop
	    View.Update
	    delay (3000)
	    %// Brings Back Cursor (it's too laggy)
	    if Sys.Exec (("\"scripts\\enableCursor.bat\"")) = true then
		put skip
	    else
		colorback (white)
		cls
		color (black)
		loop
		    locate (1, 1)
		    put "Uh oh: An Error Has Occured."
		    View.Update
		end loop
	    end if
	    CharacterCreation
	    player.Name := Character.Name
	    player.Class := Character.Class
	    player.Level := 1
	    player.HP := 10
	    player.MP := 10
	    for i : 1 .. 2
		player.Location (i) := maxx div 2
		player.Location (3) := 3
		player.Location (4) := 3
	    end for
	    if player.Class = "mage" then
		player.MP := 20
	    elsif player.Class = "warrior" then
		player.HP := 15
	    end if
	    for i : 1 .. 3
		player.ability (i) := Character.ability (i)     %// 1 = DEXTERITY(Rogue), 2 = STRENGTH(Knight), 3 = INTELLEGENCE
	    end for
	    newgame := true
	    exit
	elsif boolButton (3) = true and disableB3 = false then
	    LCO += 1
	    if LCO = 1 then
		LoadSave
		if bee = false then
		    enableCursor
		    exit
		end if
	    end if
	elsif boolButton (4) = true then
	    tempNUM2 += 1
	    if tempNUM2 = 1 then
		if Sys.Exec (("\"scripts\\exitGame.bat\"")) = true then     % // * WARNING CLOSES WHOLE TURING PROGRAM (SAVE BEFORE CLICKING EXIT BUTTON) *
		    put skip
		else
		    colorback (white)
		    cls
		    color (black)
		    loop
			locate (1, 1)
			put "Uh oh: An Error Has Occured."
			View.Update
		    end loop
		end if
	    end if
	end if

	Pic.Draw (cursor, mx, my - 28, picMerge)

	%// DEBUGING MAIN MENU
	/*locate (1, 1)
	 put ":DEBUG:" ..
	 locate (2, 1)
	 put "Current Frame: ", picNum ..
	 locate (3, 1)
	 put "Loading Frame: ", newpicNum ..*/
	View.Update
    end loop

    %// Deletes/Frees all the Main Menu Buttons
    for b : 1 .. 4
	for t : 1 .. 3
	    Pic.Free (oldPic (b, t))
	end for
    end for
    Music.PlayFileStop
    %// Deletes/Frees all the Main Menu Animations (All 100 Images)
    for i : 1 .. 100
	Pic.Free (mainMenu (i))
    end for
end MainMenu

%--------------------------
var oldx, oldy : int
type interval :
    record
	px : int
	py : int
	x1 : int
	y1 : int
	x2 : int
	y2 : int
    end record

function createinterval (px, py, x1, y1, x2, y2 : int) : interval
    var i : interval
    i.px := px
    i.py := py
    i.x1 := x1
    i.y1 := y1
    i.x2 := x2
    i.y2 := y2
    result i
end createinterval

function compareintervals (i, j : interval) : boolean
    if i.px = j.px and i.py = j.py and i.x1 >= j.x1 and i.y1 >= j.y1 and i.x2 <= j.x2 and i.y2 <= j.y2
	    then
	result true
    elsif i.px = j.px and i.py = j.py and i.x1 <= j.x1 and i.y1 <= j.y1 and i.x2 >= j.x2 and i.y2 >= j.y2
	    then
	result true
    elsif i.px = j.px and i.py = j.py and i.x1 >= j.x1 and i.y1 <= j.y1 and i.x2 <= j.x2 and i.y2 >= j.y2
	    then
	result true
    elsif i.px = j.px and i.py = j.py and i.x1 <= j.x1 and i.y1 >= j.y1 and i.x2 >= j.x2 and i.y2 <= j.y2
	    then
	result true
    else
	result false
    end if
end compareintervals

oldx := 1
oldy := 1

var current : interval
current.px := let
current.py := num
current.x1 := xLoc - 30
current.y1 := yLoc + 35
current.x2 := xLoc - 30
current.y2 := yLoc + 35

proc update_current
    current.px := let
    current.py := num
    current.x1 := xLoc
    current.x2 := xLoc
    current.y1 := yLoc
    current.y2 := yLoc
end update_current
var area : array 1 .. 291 of interval
include "Modules/data.t"

proc WorldRestriction
    for i : 1 .. 291
	update_current
	if compareintervals (current, area (i)) = true then
	    xLoc := oldx
	    yLoc := oldy
	end if
    end for
end WorldRestriction

%--------------------------

proc SaveProc
    var f1, f2 : int
    var tempStr : string
    open : f1, "Saves/" + player.Name + ".txt", put
    put : f1, player.Name
    put : f1, player.Class
    put : f1, player.Level
    put : f1, player.HP
    put : f1, player.MP
    put : f1, player.ability (1)              %// Dexterity
    put : f1, player.ability (2)              %// Strength
    put : f1, player.ability (3)              %// Intellegence
    put : f1, player.Location (1)              %// X
    put : f1, player.Location (2)              %// Y
    put : f1, player.Location (3)              %// Letter (Left, Right)
    put : f1, player.Location (4)              %// Number (Up, Down)
    close : f1
    open : f2, "Saves/Saves.txt", get
    get : f2, tempStr
    close : f2
    open : f2, "Saves/Saves.txt", put
    put : f2, strint (tempStr) + 1
    for i : 2 .. countl
	put : f2, saveL (i)
    end for
    put : f2, player.Name
    close : f2
end SaveProc

proc ChangeName
    var winID1 : int
    winID1 := Window.Open ("graphics:640;400,nobuttonbar,position:center;truemiddle,title:RPG Game,offscreenonly")
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
    var mx, my, mb : int

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
    player.Name := Name
    Window.Close (Window.GetActive)
end ChangeName

proc Save
    var tempf1 : int
    var temptempStr : string
    var tempCount : int := 0
    var tempAR : array 1 .. 10 of string
    var key, key2 : string (1)
    var bool : boolean := false
    open : tempf1, "Saves/Saves.txt", get
    loop
	tempCount += 1
	get : tempf1, temptempStr
	tempAR (tempCount) := temptempStr
	exit when eof (tempf1) = true
    end loop
    close : tempf1
    for i : 2 .. tempCount
	if tempAR (tempCount) = player.Name then
	    color (white)
	    colorback (white)
	    loop
		Font.Draw ("This save already already exists.", maxx div 2 - 200, maxy - (maxy div 8), font (2), 4)
		Font.Draw ("Do you want to overwrite?", maxx div 2 - 160, 780 - (maxy div 8), font (2), 4)
		Font.Draw ("Y/N", maxx div 2 - 20, 760 - (maxy div 8), font (2), 4)
		if hasch then
		    getch (key)
		    if key = "y" then
			SaveProc
		    elsif key = "n" then
			Font.Draw ("This save already already exists.", maxx div 2 - 200, maxy - (maxy div 8), font (2), white)
			Font.Draw ("Do you want to overwrite?", maxx div 2 - 160, 780 - (maxy div 8), font (2), white)
			Font.Draw ("Y/N", maxx div 2 - 20, 760 - (maxy div 8), font (2), white)
			loop
			    Font.Draw ("Would you like to change your", maxx div 2 - 200, maxy - (maxy div 8), font (2), 4)
			    Font.Draw ("character name instead?", maxx div 2 - 160, 780 - (maxy div 8), font (2), 4)
			    Font.Draw ("Y/N", maxx div 2 - 20, 760 - (maxy div 8), font (2), 4)
			    if hasch then
				getch (key2)
				if key2 = "y" then
				    ChangeName
				    SaveProc
				    exit
				elsif key2 = "n" then
				    exit
				end if
			    end if
			    View.Update
			end loop
			bool := true
			saveSuccessful := false
			exit
		    end if
		end if
		View.Update
	    end loop
	end if
    end for
    if bool = false then
	SaveProc
    end if
end Save

proc ResumeGame
    var id : int
    var name, classs : string
    var level, hp, mp, dex, str, intl, locx, locy, loclet, locnum : int

    open : id, "Saves/" + saveL (countl) + ".txt", get
    get : id, name
    get : id, classs
    get : id, level
    get : id, hp
    get : id, mp
    get : id, dex
    get : id, str
    get : id, intl
    get : id, locx
    get : id, locy
    get : id, loclet
    get : id, locnum
    close : id
    player.Name := name
    player.Class := classs
    player.Level := level
    player.HP := hp
    player.MP := mp
    player.ability (1) := dex
    player.ability (2) := str
    player.ability (3) := intl
    player.Location (1) := locx
    player.Location (2) := locy
    player.Location (3) := loclet
    player.Location (4) := locnum
end ResumeGame

proc animDelay
    temp += 1
    if temp = 8 then
	a += 1
	temp := 1
    end if
end animDelay

var map := Pic.FileNew ("ASSETS/IMG/map/MiddleGround_Borders.jpg")
var saveB : array 1 .. 3 of int
for i : 1 .. 3
    saveB (i) := Pic.FileNew ("ASSETS/IMG/buttons/Updated/save-" + intstr (i) + ".bmp")
end for
proc Map
    cls
    Pic.Draw (map, 70, 0, picMerge)
end Map

proc popupWindow
    var key : string (1)
    color (white)
    colorback (black)
    loop
	Font.Draw ("Are you sure you want to exit the game?", maxx div 2 - 200, maxy - (maxy div 8), font (2), 4)
	Font.Draw ("All unsaved progress will be lost.", maxx div 2 - 160, 780 - (maxy div 8), font (2), 4)
	Font.Draw ("Y/N", maxx div 2 - 20, 760 - (maxy div 8), font (2), 4)
	if hasch then
	    getch (key)
	    if key = "y" then
		if Sys.Exec (("\"scripts\\exitGame.bat\"")) = true then         % // * WARNING CLOSES WHOLE TURING PROGRAM (SAVE BEFORE CLICKING YES) *
		    put skip
		else
		    colorback (white)
		    cls
		    color (black)
		    loop
			locate (1, 1)
			put "Uh oh: An Error Has Occured."
			View.Update
		    end loop
		end if
	    elsif key = "n" then
		cls
		colorback (white)
		cls
		exit
	    end if
	end if
	View.Update
    end loop
end popupWindow

proc Escape_Menu
    cls
    var tE : array 1 .. 2 of int := init (1, 1)
    var mx, my, mb : int
    var key : string (1)
    var quitB : array 1 .. 3 of int
    for i : 1 .. 3
	quitB (i) := Pic.FileNew ("ASSETS/IMG/buttons/Updated/4-" + intstr (i) + ".bmp")
    end for
    loop
	Mouse.Where (mx, my, mb)
	Pic.Draw (map, 70, 0, picMerge)
	Pic.Draw (saveB (tE (1)), 100, maxy - 180, picMerge)
	Pic.Draw (quitB (tE (2)), 600, maxy - 180, picMerge)

	Font.Draw ("Your Current Location is " + letStr (let) + intstr (num), maxx div 2 - 220, maxy - (maxy div 10), font (3), black)

	if hasch then
	    getch (key)
	    if key = KEY_ESC then
		exit
	    end if
	end if

	if mb = 1 and mx >= 600 and my >= maxy - 180 and mx <= 877 and my <= maxy - 130 then
	    tE (2) := 3
	    popupWindow
	elsif mb = 0 and mx >= 600 and my >= maxy - 180 and mx <= 877 and my <= maxy - 130 then
	    tE (2) := 2
	else
	    tE (2) := 1
	end if

	if mb = 1 and mx >= 100 and my >= maxy - 180 and mx <= 377 and my <= maxy - 130 then
	    tE (1) := 3
	    saveSuccessful := true
	    Save
	    exit
	elsif mb = 0 and mx >= 100 and my >= maxy - 180 and mx <= 377 and my <= maxy - 130 then
	    tE (1) := 2
	else
	    tE (1) := 1
	end if

	View.Update
    end loop
end Escape_Menu

proc WINLOSE
    var tE : array 1 .. 2 of int := init (1, 1)
    var key : string (1)
    var mx, my, mb : int

    var font2 := Font.New ("Cambria:28")
    var quitB : array 1 .. 3 of int
    var LoadB : array 1 .. 3 of int
    for i : 1 .. 3
	quitB (i) := Pic.FileNew ("ASSETS/IMG/buttons/Updated/4-" + intstr (i) + ".bmp")
	LoadB (i) := Pic.FileNew ("ASSETS/IMG/buttons/Updated/3-" + intstr (i) + ".bmp")
    end for
    if lose = true then
	cls
	loop
	    colorback (black)
	    cls
	    Mouse.Where (mx, my, mb)
	    Pic.Draw (quitB (tE (2)), 600, 180, picMerge)
	    Pic.Draw (LoadB (tE (1)), 100, 180, picMerge)
	    Font.Draw ("GAME OVER", maxx div 2 - 100, maxy div 2, font2, white)
	    if mb = 1 and mx >= 600 and my >= 180 and mx <= 877 and my <= 230 then
		tE (2) := 3
		loop
		    Font.Draw ("Are you sure you want to exit the game?", maxx div 2 - 300, 780 - (maxy div 8), font2, 4)
		    Font.Draw ("All unsaved progress will be lost.", maxx div 2 - 260, 740 - (maxy div 8), font2, 4)
		    Font.Draw ("Y/N", maxx div 2 - 20, 700 - (maxy div 8), font2, 4)
		    if hasch then
			getch (key)
			if key = "y" then
			    if Sys.Exec (("\"scripts\\exitGame.bat\"")) = true then     % // * WARNING CLOSES WHOLE TURING PROGRAM (SAVE BEFORE CLICKING YES) *
				put skip
			    else
				colorback (white)
				cls
				color (black)
				loop
				    locate (1, 1)
				    put "Uh oh: An Error Has Occured."
				    View.Update
				end loop
			    end if
			elsif key = "n" then
			    cls
			    colorback (white)
			    cls
			    exit
			end if
		    end if
		    View.Update
		end loop
	    elsif mb = 0 and mx >= 600 and my >= 180 and mx <= 877 and my <= 230 then
		tE (2) := 2
	    else
		tE (2) := 1
	    end if
	    if mb = 1 and mx >= 100 and my >= 180 and mx <= 377 and my <= 230 then
		tE (1) := 3
		bee := true
		LoadSave
		exit
	    elsif mb = 0 and mx >= 100 and my >= 180 and mx <= 377 and my <= 230 then
		tE (1) := 2
	    else
		tE (1) := 1
	    end if
	    View.Update
	end loop
    elsif win = true then
	cls
	loop
	    colorback (black)
	    cls
	    Font.Draw ("BATTLE WON!", maxx div 2 - 120, maxy div 2, font2, white)
	    View.Update
	end loop
    end if
end WINLOSE

%---------------------------------------------------------------------------------
proc Game
    setscreen ("graphics:960;800,nobuttonbar,position:center;truemiddle,title:RPG Game,offscreenonly")
    var chars : array char of boolean
    var lastKey : int
    var keynotpress : boolean := false
    var times_Pressed : int := 0

    var key : string (1)

    var Map_Section : array 1 .. 8, 1 .. 8 of string
    for n : 1 .. 8
	for l : 1 .. 8
	    Map_Section (l, n) := "ASSETS/IMG/map/Sections/Map_" + chr (64 + l) + intstr (n) + ".gif"
	end for
    end for

    if resume = true then
	ResumeGame
	enableCursor
    end if

    for dir : 1 .. 4
	for a : 1 .. 3
	    player.Sprite (dir, a) := Pic.FileNew ("ASSETS/IMG/sprites/" + player.Class + "/p_" + player.Class + "_move_" + intstr (dir) + "-" + intstr (a) + ".bmp")
	end for
    end for

    charB := Pic.FileNew ("ASSETS/IMG/sprites/" + player.Class + "/p_" + player.Class + "_move_2-1.bmp")
    cl := player.Class
    var mapImage := Pic.FileNew (Map_Section (let, num))
    newgame := true
    loop
	var c1, c2, c3, c4 : int := 0
	var scalefactor : int := 15
	Pic.Draw (mapImage, 0, 0, picMerge)
	Input.KeyDown (chars)

	%// 1 = UP, 2 = LEFT, 3 = DOWN, 4 = RIGHT
	if chars (KEY_UP_ARROW) and chars (KEY_RIGHT_ARROW) then
	    yLoc += scalefactor
	    xLoc += scalefactor
	    animDelay
	    oldx := xLoc - scalefactor
	    oldy := yLoc - scalefactor
	elsif chars (KEY_UP_ARROW) and chars (KEY_LEFT_ARROW) then
	    yLoc += scalefactor
	    xLoc -= scalefactor
	    animDelay
	    oldx := xLoc + scalefactor
	    oldy := yLoc - scalefactor
	elsif chars (KEY_DOWN_ARROW) and chars (KEY_RIGHT_ARROW) then
	    yLoc -= scalefactor
	    xLoc += scalefactor
	    animDelay
	    oldx := xLoc - scalefactor
	    oldy := yLoc + scalefactor
	elsif chars (KEY_DOWN_ARROW) and chars (KEY_LEFT_ARROW) then
	    yLoc -= scalefactor
	    xLoc -= scalefactor
	    animDelay
	    oldx := xLoc + scalefactor
	    oldy := yLoc + scalefactor
	elsif chars (KEY_UP_ARROW) then
	    yLoc += scalefactor
	    animDelay
	    c1 += 1
	    if c1 = 1 then
		oldx := xLoc
		oldy := yLoc - scalefactor
	    else
		oldy := yLoc - scalefactor
	    end if
	    dir := up
	elsif chars (KEY_LEFT_ARROW) then
	    xLoc -= scalefactor
	    animDelay
	    c4 += 1
	    if c4 = 1 then
		oldy := yLoc
		oldx := xLoc + scalefactor
	    else
		oldx := xLoc + scalefactor
	    end if
	    dir := left
	elsif chars (KEY_DOWN_ARROW) then
	    yLoc -= scalefactor
	    animDelay
	    c2 += 1
	    if c2 = 1 then
		oldx := xLoc
		oldy := yLoc + scalefactor
	    else
		oldy := yLoc + scalefactor
	    end if
	    dir := down
	elsif chars (KEY_RIGHT_ARROW) then
	    xLoc += scalefactor
	    animDelay
	    c3 += 1
	    if c3 = 1 then
		oldy := yLoc
		oldx := xLoc - scalefactor
	    else
		oldx := xLoc - scalefactor
	    end if
	    dir := right
	else
	    keynotpress := true
	end if
	delay (40)
	lastKey := dir

	if a > 3 then
	    a := 2
	end if

	if keynotpress = false then
	    Pic.Draw (player.Sprite (lastKey, a), xLoc, yLoc, picMerge)
	end if

	if keynotpress = true then
	    Pic.Draw (player.Sprite (lastKey, 1), xLoc, yLoc, picMerge)
	    keynotpress := false
	end if

	if saveSuccessful = true then
	    Font.Draw ("Save Complete!", maxx div 2 - 80, maxy div 2, font (2), green)
	    View.Update
	    delay (2000)
	    saveSuccessful := false
	end if

	%// ESCAPE MENU
	if hasch then
	    getch (key)
	    if key = KEY_ESC then
		Escape_Menu
	    end if
	end if

	player.Location (1) := xLoc
	player.Location (2) := yLoc
	player.Location (3) := let
	player.Location (4) := num

	if newgame = true then
	    loop
		Pic.Draw (note, 170, 20, picMerge)

		Font.Draw ("Greetings, " + player.Name, 230, 600, font (2), black)
		Font.Draw ("You have been chosen to slay the", 230, 540, font (2), black)
		Font.Draw ("dragon that is terrorizing the city!", 230, 480, font (2), black)
		Font.Draw ("Head to the city hall located in D3, the", 230, 320, font (2), black)
		Font.Draw ("dragon is there right now!", 230, 260, font (2), black)

		Font.Draw ("HINT: Press escape to see information.", 230, 100, font (2), 4)
		View.Update
		if hasch then
		    getch (key)
		    if key = KEY_ESC then
			newgame := false
			exit
		    end if
		end if
	    end loop
	end if

	if let = 4 and num = 3 and xLoc >= 495 and yLoc >= 450 and xLoc <= 555 and yLoc <= 510 then
	    cls
	    colorback (black)
	    cls
	    View.Update
	    delay (1000)
	    exit
	end if

	%// CHECKS IF PLAYER IS ON BORDER OF MAP
	if xLoc > maxx then
	    let += 1
	    if let > 8 then
		let := 8
		xLoc := maxx
	    else
		xLoc := 1
	    end if
	    mapImage := Pic.FileNew (Map_Section (let, num))
	elsif yLoc > maxy then
	    num -= 1
	    if num < 1 then
		num := 1
		yLoc := maxy
	    else
		yLoc := 1
	    end if
	    mapImage := Pic.FileNew (Map_Section (let, num))
	elsif xLoc < 1 then
	    let -= 1
	    if let < 1 then
		let := 1
		xLoc := 1
	    else
		xLoc := maxx
	    end if
	    mapImage := Pic.FileNew (Map_Section (let, num))
	elsif yLoc < 1 then
	    num += 1
	    if num > 8 then
		num := 8
		yLoc := 1
	    else
		yLoc := maxy
	    end if
	    mapImage := Pic.FileNew (Map_Section (let, num))
	end if
	WorldRestriction
	View.Update
	cls
    end loop
    fork battle_dragon
    colorback (white)
    cls
    BS
end Game

proc _Music         % Determines which music to play based on location
    var temp : int := Rand.Int (1, 2)
    if temp = 1 then
	fork play_music
    else
	fork play_autumn_voyage
    end if
end _Music

MainMenu
%Window.Close (Window.GetActive)

_Music
%player.Class := "mage"
loop
    Game
    WINLOSE
    xLoc := player.Location(1)
    yLoc := player.Location(2)
    let := player.Location(3)
    num := player.Location(4)
    lose := false
    win := false
    colorback (white)
    cls
end loop
