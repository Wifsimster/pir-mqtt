require('config')
require('functions')

gpio.mode(DATA_PIN, gpio.INT)

mac = wifi.sta.getmac()
ip = wifi.sta.getip()
m = mqtt.Client(CLIENT_ID, 120, "", "")

m:lwt("/lwt", '{"message":"'..CLIENT_ID..'","topic":"'..DATA_TOPIC..'","ip":"'..ip..'"}', 0, 0)

-- Try to reconnect to broker when communication is down
m:on("offline", function(con)
    ip = wifi.sta.getip()
    print ("MQTT reconnecting to " .. BROKER_IP .. " from " .. ip)
    tmr.alarm(1, 10000, 0, function()
        node.restart();
    end)
end)

print("Connecting to "..BROKER_IP..":"..BROKER_PORT.."...")
m:connect(BROKER_IP, BROKER_PORT, 0, 1, function(conn)
    print("Connected to "..BROKER_IP..":"..BROKER_PORT.." as "..CLIENT_ID)
    mqtt_subscribe()
    mqtt_online()
    mqtt_ping()
    gpio.trig(DATA_PIN, 'both', mqtt_publish)
end)