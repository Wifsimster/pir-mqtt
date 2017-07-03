require('config')
require('functions')

gpio.mode(DATA_PIN, gpio.INT)

mac = wifi.sta.getmac()
ip = wifi.sta.getip()
m = mqtt.Client(CLIENT_ID, 120, "", "")

m:lwt("/lwt", '{"mac":"'..mac..'"}', 0, 0)

-- Try to reconnect to broker when communication is down
m:on("offline", function(con)
    ip = wifi.sta.getip()
    print ("MQTT reconnecting to "..BROKER_IP.." from "..ip)
    tmr.alarm(1, 10000, 0, function()
        node.restart()
    end)
end)

m:on("message", function(conn, topic, data)
    print("Message received: " .. topic .. " : " .. data)
    parse = cjson.decode(data)
    mac = parse.mac
    action = parse.action
    if(mac == wifi.sta.getmac()) then
        if (action == "STATE") then
            mqtt_state()
        elseif (action == "PING") then
            mqtt_ping()
        elseif (action == "ONLINE") then
            mqtt_online()
        elseif (action == "IP") then
            mqtt_ip()
        elseif (action == "NAME") then
            mqtt_name()
        elseif (action == "TYPE") then
            mqtt_type()
        elseif (action == "RESET") then
            print("Restart node")
            node.restart()
        else
            print("Invalid action (" .. action .. ")")
        end
    end
end)

print("Connecting to "..BROKER_IP..":"..BROKER_PORT.."...")
m:connect(BROKER_IP, BROKER_PORT, 0, 1, function(conn)
    print("Connected to "..BROKER_IP..":"..BROKER_PORT.." as "..CLIENT_ID)
    mqtt_online()
    mqtt_subscribe()
    gpio.trig(DATA_PIN, 'both', mqtt_state)
end)
