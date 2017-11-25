-- requirements: gpio, net, pwm, wifi (local: motor, +network)
server = {
  port = 9100
}
dc = {
  pin = 6,
  input1 = 7,
  input2 = 5
}
servo = {
  pin = 8,
  input1 = 2,
  input2 = 1
}
ledPower = {
  pin = 3
}
ledNetwork = {
  pin = 4
}
threshold = 1000

-- motor
motor = require("motor")
motor.setup(dc.pin, dc.input1, dc.input2)
motor.setup(servo.pin, servo.input1, servo.input2)

-- leds
gpio.mode(ledNetwork.pin, gpio.OUTPUT)
gpio.mode(ledPower.pin, gpio.OUTPUT)
gpio.write(ledPower.pin, gpio.HIGH)

-- network
network = require("network")
network.setup("SSID", "password")

function receive(socket, data, port, ip)
  print(string.format("received '%s' from %s:%d", data, ip, port))
  socket:send(port, ip, "echo: " .. data) -- TODO: need to understand this one

  gpio.write(ledNetwork.pin, gpio.HIGH)

  if data ~= nil then
    local command = tonumber(data)
    local power = command - threshold

    if command < 2000 then -- servo:left
      motor.on(servo.pin, servo.input1, servo.input2, power)
    elseif command < 3000 then -- servo:right
      motor.on(servo.pin, servo.input2, servo.input1, power)
    elseif command < 4000 then -- servo:center
      motor.neutral(servo.pin)
    elseif command < 5000 then -- dc:park
      motor.stop(dc.pin, dc.input1, dc.input2)
    elseif command < 6000 then -- dc:reverse
      motor.on(dc.pin, dc.input2, dc.input1, power)
    elseif command < 7000 then -- dc:neutral
      motor.neutral(dc.pin)
    elseif command < 8000 then -- dc:drive
      motor.on(dc.pin, dc.input1, dc.input2, power)
    end
  end

  gpio.write(ledNetwork.pin, gpio.LOW)
end

-- udpSocket: UDP is connection less
udpSocket = net.createUDPSocket()
udpSocket:listen(server.port)
udpSocket:on("receive", receive)
port, ip = udpSocket:getaddr()
print(string.format("local UDP socket address / port: %s:%d", ip, port))
-- TODO: after 1s without messages on UDP, stop the engine
