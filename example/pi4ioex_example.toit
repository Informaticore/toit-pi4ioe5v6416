import i2c
import pi4ioex
import gpio

main:
  bus0 := i2c.Bus
    --sda=gpio.Pin 9
    --scl=gpio.Pin 10

  bus1 := i2c.Bus
    --sda=gpio.Pin 11
    --scl=gpio.Pin 12

  print "Bus1: $bus1.scan"
  print "Bus0: $bus0.scan"

  ioA := pi4ioex.PI4IOEX (bus0.device 0x20)
  ioB := pi4ioex.PI4IOEX (bus0.device 0x21)

  P0 := ioA.get-pin 1 0 
  while true:
    print "an"
    P0.on
    sleep --ms=1000
    print "aus"
    P0.off
    sleep --ms=1000

  // //set all output EXA
  // gpioExpanderA.registers.write-u8 0x06 0b00
  // gpioExpanderA.registers.write-u8 0x07 0b00
  // //set all LOW EXA
  // gpioExpanderA.registers.write-u8 0x02 0x00
  // gpioExpanderA.registers.write-u8 0x03 0x00
  // //set all output EXB
  // gpioExpanderB.registers.write-u8 0x06 0b00
  // gpioExpanderB.registers.write-u8 0x07 0b00
  // //set all LOW EXB
  // gpioExpanderB.registers.write-u8 0x02 0x00
  // gpioExpanderB.registers.write-u8 0x03 0x00

  // while true:
  //   print "an"
  //   gpioExpanderB.registers.write-u8 0x03 0b0000_0011
  //   sleep --ms=1000
  //   print "aus"
  //   gpioExpanderB.registers.write-u8 0x03 0b00
  //   sleep --ms=1000