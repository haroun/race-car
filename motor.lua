local motor = {}

function pwmOff(enable)
  pwm.stop(enable)
  pwm.close(enable)
end

function motor.setup(enable, input1, input2)
  gpio.mode(enable, gpio.OUTPUT)
  gpio.mode(input1, gpio.OUTPUT)
  gpio.mode(input2, gpio.OUTPUT)

  gpio.write(enable, gpio.LOW)
  gpio.write(input1, gpio.LOW)
  gpio.write(input2, gpio.LOW)
end

function motor.on(enable, input1, input2, power)
  if power ~= nil and power < 90 then
    pwm.setup(enable, 120, 0)
    pwm.setduty(enable, power*10+100)
    pwm.start(enable)
  else
    pwmOff(pin)
  end

  gpio.write(enable, gpio.HIGH)
  gpio.write(input1, gpio.HIGH)
  gpio.write(input2, gpio.LOW)
end

function motor.stop(enable, input1, input2)
  pwmOff(enable)

  gpio.write(enable, gpio.HIGH)
  gpio.write(input1, gpio.LOW)
  gpio.write(input2, gpio.LOW)
end

function motor.neutral(enable)
  pwmOff(enable)

  gpio.write(enable, gpio.LOW)
end

return motor
