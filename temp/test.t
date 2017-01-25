setscreen ("graphics:1190;670,nobuttonbar,position:center;truemiddle,title:RPG Game,offscreenonly")
var numFrames := Pic.Frames ("mainmenu.gif")
var delayTime : int
var pics : array 1 .. numFrames of int

Pic.FileNewFrames ("mainmenu.gif", pics, delayTime)

delayTime -= 50
loop
    locate (1, 1)
    put delayTime
    for i : 1 .. numFrames
	Pic.Draw (pics (i), 0, 0, picCopy)
	delay (delayTime)
	View.Update
	cls
    end for
end loop

for i : 1 .. numFrames
    Pic.Free (pics (i))
end for
