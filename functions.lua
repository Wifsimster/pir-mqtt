require('config')

-- Publish MQTT activity to broker
function mqtt_publish()
    --if(gpio.read(DATA_PIN) ~= val) then
        --val = gpio.read(DATA_PIN)
        DATA = '{"mac":"'..wifi.sta.getmac()..'", "ip":"'..ip..'",'
        DATA = DATA..'"state":"'..gpio.read(DATA_PIN)..'"}'
        m:publish(DATA_TOPIC, DATA, 0, 0, function(conn)
            print(DATA_TOPIC.." : "..CLIENT_ID.." - "..DATA)         
        end)
    --end
end

-- Subscribe to MQTT broker
function mqtt_subscribe()
    m:subscribe(DATA_TOPIC, 2, function(m)
        print("Successfully subscribed to the topic: "..DATA_TOPIC)
    end)
end

-- Say hello to MQTT broker
function mqtt_online()
    DATA = '{"mac":"'..mac..'","ip":"'..ip..'","name":"'..CLIENT_ID..'","type":"'..DEVICE_TYPE..'"}'
    m:publish(ONLINE_TOPIC, DATA, 0, 0, function(conn)
        print(ONLINE_TOPIC.." : "..CLIENT_ID)
    end)
end

-- Ping MQTT broker
function mqtt_ping()
    tmr.create():alarm(10000, tmr.ALARM_AUTO, function(cb_timer)
        DATA = '{"mac":"'..mac..'"}'
        m:publish(PING_TOPIC, DATA, 0, 0, function(conn)
            print(PING_TOPIC.." : "..CLIENT_ID)
        end)
    end)
end