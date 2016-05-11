require('config')

DATA_PIN = 3 -- GPIO_0

gpio.mode(DATA_PIN, gpio.INPUT)

-- MQTT client
TOPIC = "/sensors/bureau/pir/data"

-- Init client with keepalive timer 120sec
m = mqtt.Client(CLIENT_ID, 120, "", "")

function publish()
    DATA = '{"mac":"'..wifi.sta.getmac()..'", "ip":"'..wifi.sta.getip()..'",'
    DATA = DATA..'"motion":"'..gpio.read(DATA_PIN)..'"}'
    m:publish(TOPIC, DATA, 0, 0, function(conn)
        print(CLIENT_ID.." sending data: "..DATA.." to "..TOPIC)
    end)
end
        
tmr.alarm(2, 1000, 1, function()
    tmr.stop(2)
    print("Connecting to MQTT: "..BROKER_IP..":"..BROKER_PORT.."...")
    m:connect(BROKER_IP, BROKER_PORT, 0, function(conn)
        print("Connected to MQTT: "..BROKER_IP..":"..BROKER_PORT.." as "..CLIENT_ID)

        DATA = '{"mac":"'..wifi.sta.getmac()..'", "ip":"'..wifi.sta.getip()..'",'
        DATA = DATA..'"motion":"'..gpio.read(DATA_PIN)..'"}'
        
        -- Publish a message (QoS = 0, retain = 0)
        m:publish(TOPIC, DATA, 0, 0, function(conn)
            print(CLIENT_ID.." sending data: "..DATA.." to "..TOPIC)
        end)
        
        gpio.trig(DATA_PIN, 'both', publish)
    end)
end)

m:close();
