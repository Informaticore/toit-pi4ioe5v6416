import serial
import .constants show Direction PullUpDown Register

class PI4IOEX:

  registers_/serial.Registers

  constructor device/serial.Device:
    registers_ = device.registers 

  read-pin pin/int -> int:
    assert: pin >= 0 and pin <= 15
    reg_ := pin >= 8 ? Register.INPUT_PORT_1 : Register.INPUT_PORT_0
    pin_ := pin % 8
    return (read_ reg_ >> pin_) & 1

  write-pin pin/int value/int:
    assert: pin >= 0 and pin <= 15
    reg_ := pin >= 8 ? Register.OUTPUT_PORT_1 : Register.OUTPUT_PORT_0
    pin_ := pin % 8
    current_state := read_ reg_
    new_state := (current_state & ~(1 << pin_)) | (value << pin_)
    write_ reg_ new_state

  //TODO implement invert polarity register

  set-direction pin/int direction/int:
    assert: pin >= 0 and pin <= 15
    reg_ := pin >= 8 ? Register.CONFIGURATION_PORT_1 : Register.CONFIGURATION_PORT_0
    pin_ := pin % 8
    current_state := read_ reg_
    new_state := (current_state & ~(1 << pin_)) | (direction << pin_)
    print "set pin $pin_ to $direction. Current state: $(%b current_state). New state: $(%b new_state)."
    write_ reg_ new_state

  enable-pull-up-down pin/int enable/bool:
    assert: pin >= 0 and pin <= 15
    reg_ := pin >= 8 ? Register.PULL-UP-DOWN-ENABLE-REGISTER-1 : Register.PULL_UP_DOWN_ENABLE_REGISTER_0
    pin_ := pin % 8
    current_state := read_ reg_
    new_state := (current_state & ~(1 << pin)) | (enable ? 1 : 0 << pin)
    write_ reg_ new_state

  pull-up-down pin/int pull-up-down/int:
    assert: pin >= 0 and pin <= 15
    reg_ := pin >= 8 ? Register.PULL-UP-DOWN-SELECTION-REGISTER-1 : Register.PULL-UP-DOWN-SELECTION-REGISTER-0
    pin_ := pin % 8
    current_state := read_ reg_
    new_state := (current_state & ~(1 << pin)) | (pull_up_down << pin)
    write_ reg_ new_state

  //TODO implement interrupt control register

  get-pin pin/int direction=Direction.IN pull-up-down=PullUpDown.DISABLED -> Pin:
    return Pin this pin --direction=direction --pull-up-down=pull-up-down

  write_ register/int value/int:
    registers_.write-u8 register value

  read_ register/int:
    return registers_.read-u8 register

class Pin:
  static LOW ::= 0
  static HIGH ::= 1

  ioex_/PI4IOEX
  pin_/int
  direction_/int

  constructor ioex/PI4IOEX pin/int --direction/int=Direction.IN --pull-up-down/int=PullUpDown.DISABLED:
    ioex_ = ioex
    pin_ = pin
    direction_ = direction
    ioex_.set-direction pin direction
    if direction == Direction.IN:
      if pull-up-down == PullUpDown.PULL-DOWN:
        ioex_.enable-pull-up-down pin true
        ioex_.pull-up-down pin PullUpDown.PULL-DOWN
      else if pull-up-down == PullUpDown.PULL-UP:
        ioex_.enable-pull-up-down pin true
        ioex_.pull-up-down pin PullUpDown.PULL-UP
      else if pull-up-down == PullUpDown.DISABLED:
        ioex_.enable-pull-up-down pin false
      else:
        throw "Invalid pull-up-down value."

  on:
    if direction_ == Direction.IN:
      throw "Pin is set to input, cannot be set to high."
    ioex_.write-pin pin_ HIGH

  off:
    if direction_ == Direction.IN:
      throw "Pin is set to input, cannot be set to low."
    ioex_.write-pin pin_ LOW

  value:
    return ioex_.read-pin pin_
  