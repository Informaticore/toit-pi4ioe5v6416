# toit-pi4ioe5v9535
Library to control a PI4IOE5V9535 GPIO Expander. Other variants of the PI4IOE5Vxxx should work as well but I have not tested it yet.

```
import i2c
import pi4ioex
import gpio

main:
  bus0 := i2c.Bus
    --sda=gpio.Pin 9
    --scl=gpio.Pin 10

  print "Bus0: $bus0.scan"

  ioA := pi4ioex.PI4IOEX (bus0.device 0x20)

  P0 := ioA.get-pin 1 0 
  while true:
    print "an"
    P0.on
    sleep --ms=1000
    print "aus"
    P0.off
    sleep --ms=1000
```