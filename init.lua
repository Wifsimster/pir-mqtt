require('config')

print("Setting up WIFI...")

wifi.setmode(wifi.STATION)
wifi.sta.config(AP,PWD)
wifi.sta.connect()

tmr.alarm(1, 1000, 1, function() 
    if wifi.sta.getip()== nil then 
        print("Waiting...") 
    else 
        tmr.stop(1)
        print("IP is "..wifi.sta.getip())
        dofile("main.lua")
    end 
end)
