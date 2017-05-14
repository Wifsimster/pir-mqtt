require('config')

TOPIC = "/sensors/pir/data"

gpio.mode(DATA_PIN, gpio.INT)

m = mqtt.Client(CLIENT_ID, 120, "", "")
ip = wifi.sta.getip()
val = 1

m:lwt("/lwt", '{"message":"'..CLIENT_ID..'", "topic":"'..TOPIC..'", "ip":"'..ip..'"}', 0, 0)

-- Try to reconnect to broker when communication is down
m:on("offline", function(con)
    ip = wifi.sta.getip()
    print ("MQTT reconnecting to " .. BROKER_IP .. " from " .. ip)
    tmr.alarm(1, 10000, 0, function()
        node.restart();
    end)
end)

print("Connecting to MQTT: "..BROKER_IP..":"..BROKER_PORT.."...")

m:connect(BROKER_IP, BROKER_PORT, 0, 1, function(conn)
    print("Connected to MQTT: "..BROKER_IP..":"..BROKER_PORT.." as "..CLIENT_ID)

    DATA = '{"mac":"'..wifi.sta.getmac()..'", "ip":"'..ip..'", "online":"true"}'
        
    m:publish(TOPIC, DATA, 0, 0, function(conn)
        print(CLIENT_ID.." sending online: "..DATA.." to "..TOPIC)
    end)
    
    gpio.trig(DATA_PIN, 'both', publish)
        
end)

function publish(timestamp)
    print(timestamp)
    if(gpio.read(DATA_PIN) ~= val) then
        val = gpio.read(DATA_PIN)
        DATA = '{"mac":"'..wifi.sta.getmac()..'", "ip":"'..ip..'",'
        DATA = DATA..'"state":"'..gpio.read(DATA_PIN)..'"}'
        m:publish(TOPIC, DATA, 0, 0, function(conn)
            print(CLIENT_ID.." sending data: "..DATA.." to "..TOPIC)            
        end)
    end
end
