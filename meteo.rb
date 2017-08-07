require 'rubygems'
require "dht-sensor-ffi"
require 'pi_piper'
require './temperature_pressure_sensor.rb'
#require 'byebug'
include PiPiper

require 'net/http'
require 'json'

class Meteo

  URL = 'http://55ddfe79.ngrok.io/meteos'

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
      temp_pres = get_temp_pres
      temp = @sensor.temp
      humidity = @sensor.humidity
      print_meteo(temp, humidity, temp_pres)
      wich_led_to_light(temp)
      send_meteo(temp_pres, humidity)
      sleep(1800)
   end
  end

  def send_meteo(temp_pres, humidity)
    uri = URI(URL)
    http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = { temperature: temp_pres.temp, pressure: temp_pres.pressure, humidity: humidity }.to_json
    puts req.body
    res = http.request(req)
  end

  #  uri = URI('http://api.nsa.gov:1337/agent')
  #  http = Net::HTTP.new(uri.host, uri.port)
  #  req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
  #  req.body = {name: 'John Doe', role: 'agent'}.to_json
  #  res = http.request(req)
  #  puts "response #{res.body}"

  def print_meteo(temp, humidity, temp_pres)
    puts "Temperature = #{temp}°c; Humidité = #{humidity}%, other captor: temp: #{temp_pres.temp / 10.0}, pres: #{temp_pres.pressure}"
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

  def get_temp_pres
    temp_pres = TemperaturePressureSensor.new("/dev/i2c-1")
    temp_pres.read(3) # highest accuracy
  end
end

meteo = Meteo.new()

meteo.wich_led_to_light(60)
