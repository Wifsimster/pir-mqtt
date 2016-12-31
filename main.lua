require('config')

-- MQTT client
TOPIC = "/sensors/pir/data"

gpio.mode(DATA_PIN, gpio.INPUT)

-- Init client with keepalive timer 120sec
m = mqtt.Client(CLIENT_ID, 120, "", "")

ip = wifi.sta.getip()

m:lwt("/offline", '{"message":"'..CLIENT_ID..'", "topic":"'..TOPIC..'", "ip":"'..ip..'"}', 0, 0)

function publish()
    DATA = '{"mac":"'..wifi.sta.getmac()..'", "ip":"'..ip..'",'
    DATA = DATA..'"state":"'..gpio.read(DATA_PIN)..'"}'
    m:publish(TOPIC, DATA, 0, 0, function(conn)
        print(CLIENT_ID.." sending data: "..DATA.." to "..TOPIC)
    end)
end
        
print("Connecting to MQTT: "..BROKER_IP..":"..BROKER_PORT.."...")
m:connect(BROKER_IP, BROKER_PORT, 0, 1, function(conn)
    print("Connected to MQTT: "..BROKER_IP..":"..BROKER_PORT.." as "..CLIENT_ID)
    gpio.trig(DATA_PIN, 'both', publish)
end)
