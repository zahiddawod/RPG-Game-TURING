setscreen ("graphics:960;800,nobuttonbar,position:center;truemiddle,title:RPG Game")
var mx, my, mb : int
var chars : array char of boolean
var let, num : int := 3

var Map_Section : array 1 .. 8, 1 .. 8 of string
for n : 1 .. 8
    for l : 1 .. 8
	Map_Section (l, n) := "assets/img/map/Sections/Map_" + chr (64 + l) + intstr (n) + ".gif"
    end for
end for

var mapImage := Pic.FileNew (Map_Section (let, num))

loop
    mapImage := Pic.FileNew (Map_Section (let, num))
    Pic.Draw (mapImage, 0, 0, picCopy)
    Mouse.Where (mx, my, mb)
    locate (1, 1)
    put "X: ", mx, " Y: ", my, " B: ", mb
    Input.KeyDown (chars)

    if chars (KEY_UP_ARROW) then
	num -= 1
    elsif chars (KEY_DOWN_ARROW) then
	num += 1
    elsif chars (KEY_RIGHT_ARROW) then
	let += 1
    elsif chars (KEY_LEFT_ARROW) then
	let -= 1
    end if

    if let > 8 then
	let := 8
    elsif num > 8 then
	num := 8
    elsif let < 1 then
	let := 1
    elsif num < 1 then
	num := 1
    end if
end loop
%  x   y
%> 225 440
%< 800 780
