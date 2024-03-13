import serial
import .constants show Direction PullUpDown

class PI4IOEX:

  registers_/serial.Registers

  constructor device/serial.Device:
    registers_ = device.registers 

  set_output pin/int:
    current_state := registers_.read-u8 0x06
    registers_.write-u8 0x06 current-state << pin

  write_ register/int value/int:
    registers_.write-u8 register value

class IOExPin:
  ioex_/PI4IOEX
  pin_/int
  direction_/int
  pull-up-down_/int

  constructor ioex/PI4IOEX pin/int --direction/int=Direction.OUT --pull-up-down/int=PullUpDown.DISABLE:
    ioex_ = ioex
    pin_ = pin
    direction_ = direction
    pull-up-down_ = pull_up_down
  
  on:
    ioex_.write_ pin_ value