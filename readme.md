Ruby Meteo Station

To play with raspberry PI.

Need :
- rvm https://rvm.io/
- bcm2835 lib : http://www.airspayce.com/mikem/bcm2835/

To install the bmc2835 library :
```
  # download the latest version of the library, say bcm2835-1.xx.tar.gz, then:
  tar zxvf bcm2835-1.xx.tar.gz
  cd bcm2835-1.xx
  ./configure
  make
  sudo make check
  sudo make install
```
First install bundle
`gem install bundle`

Then run `bundle install`

And to run the project :
`rvmsudo meteo.rb`
