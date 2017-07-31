require 'rubygems'
require "dht-sensor-ffi"
require 'pi_piper'
include PiPiper

class Meteo
  def initialize
    @on_led = PiPiper::Pin.new(pin: 26, direction: :out)
    @sensor = DhtSensor.read(21, 11)
    light(@on_led)
    get_meteo
  end

  def get_meteo
    while true do
      puts @sensor.temp               # => 21.899999618530273 (temp in C)
      puts @sensor.humidity           # => 22.700000762939453 (relative humidity %)
      sleep(5) 
   end
  end

  def light(led)
    led.on
  end
end

Meteo.new()
