require 'rubygems'
require "dht-sensor-ffi"
require 'pi_piper'
require './temperature_pressure_sensor.rb'
#require 'byebug'
include PiPiper

class Meteo
  def initialize
    @on_led = PiPiper::Pin.new(pin: 26, direction: :out)
    @white_led = PiPiper::Pin.new(pin: 5, direction: :out)
    @yellow_led =  PiPiper::Pin.new(pin: 6, direction: :out)
    @red_led = PiPiper::Pin.new(pin: 13, direction: :out)
    puts 'on'
    light(@on_led)
    get_meteo
  end

  def get_meteo
    while true do
      @sensor = DhtSensor.read(21, 11)
      temp = @sensor.temp
      humidity = @sensor.humidity
      print_meteo(temp, humidity)
      wich_led_to_light(temp)
      sleep(5)
   end
  end

  def print_meteo(temp, humidity)
    puts "Temperature = #{temp}°c; Humidité = #{humidity}%"
  end

  def wich_led_to_light(temp)
    stop_all_led
    case
      when temp <= 15 then @white_led.on
      when temp.between?(16,25) then @yellow_led.on
      when temp > 25 then @red_led.on
    end
  end

  def light(led)
    led.on
  end

  def light_all_led
    all_led.each { |led| led.on }
  end

  def stop_all_led
    all_led.each { |led| led.off }
  end

  def all_led
    [@white_led, @yellow_led, @red_led]
  end
end

meteo = Meteo.new()

meteo.wich_led_to_light(60)
