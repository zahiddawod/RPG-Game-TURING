var mx, my, mb : int
Music.PlayFile ("inventory.wav")
loop
    Mouse.Where (mx, my, mb)

    if mb = 1 then
	Music.PlayFile ("inventory.wav")
    end if
end loop
