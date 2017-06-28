# Motion sensor

> This LUA script is for ESP8266 hardware.

## Description

Send motion sensor data through an ESP8266 to a MQTT broker

## Principle

1. Connect to a wifi AP
2. Start a MQTT client and try to connect to a MQTT broker, restart until it does
3. Publish data to MQTT broker each time data changes (motion detection)
4. MQTT broker can manualy : 
- Get the current state : `{ mac: #DEVICE_MAC#, action: "STATE"}`
- Ping the device : `{ mac: #DEVICE_MAC#, action: "PING"}`
- Force to send an online message : `{ mac: #DEVICE_MAC#, action: "ONLINE"}`
- Get the device IP : `{ mac: #DEVICE_MAC#, action: "IP"}`
- Get the device name : `{ mac: #DEVICE_MAC#, action: "NAME"}`
- Get the device type : `{ mac: #DEVICE_MAC#, action: "TYPE"}`
- Restart the device : `{ mac: #DEVICE_MAC#, action: "RESET"}`

## Scheme

![scheme](https://github.com/Wifsimster/pir-mqtt/blob/master/scheme.png)
