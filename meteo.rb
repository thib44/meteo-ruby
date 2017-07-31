require 'rubygems'
require "dht-sensor-ffi"
require 'pi_piper'
include PiPiper

led = PiPiper::Pin.new(pin: 26, direction: :out)

led.on
val = DhtSensor.read(21, 11) # pin=21, sensor type=DHT-11
puts val.temp               # => 21.899999618530273 (temp in C)
puts val.humidity           # => 22.700000762939453 (relative humidity %)
