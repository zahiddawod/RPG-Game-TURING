if Sys.Exec (("\"scripts\exitGame.bat\"")) = true then 
    put "Everything went smoothly!" 
else 
    put "Uh oh: ", Error.LastMsg 
end if
