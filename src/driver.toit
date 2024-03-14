import serial
import .constants show Direction PullUpDown Register

class PI4IOEX:

  registers_/serial.Registers

  constructor device/serial.Device:
    registers_ = device.registers 

  /**
  * Read the value of the given pin.
  */
  read-pin pin/int -> int:
    assert: pin >= 0 and pin <= 15
    reg_ := pin >= 8 ? Register.INPUT_PORT_1 : Register.INPUT_PORT_0
    pin_ := pin % 8
    return (read_ reg_ >> pin_) & 1

  /**
  * Write the value 0 (LOW) or 1 (HIGH) to the given pin to drive its output. 
  */
  write-pin pin/int value/int:
    assert: pin >= 0 and pin <= 15
    assert: value == 0 or value == 1
    reg_ := pin >= 8 ? Register.OUTPUT_PORT_1 : Register.OUTPUT_PORT_0
    pin_ := pin % 8
    current_state := read_ reg_
    new_state := (current_state & ~(1 << pin_)) | (value << pin_)
    write_ reg_ new_state

  /**
  * Enable or disable the polarity inversion of the given pin.
  */
  enable-polarity-inversion pin/int enable/bool:
    assert: pin >= 0 and pin <= 15
    reg_ := pin >= 8 ? Register.POLARITY-INVERSION-PORT-1 : Register.POLARITY-INVERSION-PORT-0
    pin_ := pin % 8
    current_state := read_ reg_
    new_state := (current_state & ~(1 << pin_)) | (enable ? 1 : 0 << pin_)
    write_ reg_ new_state

  /**
  * Set the direction of the given pin to be input or output.
  */
  set-direction pin/int direction/int:
    assert: pin >= 0 and pin <= 15
    assert: direction == Direction.OUT or direction == Direction.IN
    reg_ := pin >= 8 ? Register.CONFIGURATION_PORT_1 : Register.CONFIGURATION_PORT_0
    pin_ := pin % 8
    current_state := read_ reg_
    new_state := (current_state & ~(1 << pin_)) | (direction << pin_)
    print "set pin $pin_ to $direction. Current state: $(%b current_state). New state: $(%b new_state)."
    write_ reg_ new_state

  /**
  * Enable or disable the pull-up/down resistor of the given pin.
  */
  enable-pull-up-down pin/int enable/bool:
    assert: pin >= 0 and pin <= 15
    reg_ := pin >= 8 ? Register.PULL-UP-DOWN-ENABLE-REGISTER-1 : Register.PULL_UP_DOWN_ENABLE_REGISTER_0
    pin_ := pin % 8
    current_state := read_ reg_
    new_state := (current_state & ~(1 << pin)) | (enable ? 1 : 0 << pin)
    write_ reg_ new_state

  /**
  * Set the pull-up/down resistor of the given pin to be pull-up or pull-down.
  * @param pin The pin number.
  * @param pull_up_down The pull-up/down resistor of the pin, either PullUpDown.PULL-UP, PullUpDown.PULL-DOWN or PullUpDown.DISABLED.
  */
  pull-up-down pin/int pull-up-down/int:
    assert: pin >= 0 and pin <= 15
    reg_ := pin >= 8 ? Register.PULL-UP-DOWN-SELECTION-REGISTER-1 : Register.PULL-UP-DOWN-SELECTION-REGISTER-0
    pin_ := pin % 8
    current_state := read_ reg_
    new_state := (current_state & ~(1 << pin)) | (pull_up_down << pin)
    write_ reg_ new_state

  //TODO implement interrupt control register

  /**
  * Get the pin object for the given pin.
  * @param pin The pin number.
  * @param direction The direction of the pin, either Direction.IN or Direction.OUT.
  * @param pull-up-down The pull-up/down resistor of the pin, either PullUpDown.PULL-UP, PullUpDown.PULL-DOWN or PullUpDown.DISABLED.
  */
  get-pin pin/int direction=Direction.IN pull-up-down=PullUpDown.DISABLED -> Pin:
    return Pin this pin --direction=direction --pull-up-down=pull-up-down

  write_ register/int value/int:
    registers_.write-u8 register value

  read_ register/int:
    return registers_.read-u8 register

  reset:
    registers_.write-u8 Register.OUTPUT-PORT-0 0xff
    registers_.write-u8 Register.OUTPUT-PORT-1 0xff
    registers_.write-u8 Register.POLARITY-INVERSION-PORT-0 0x00
    registers_.write-u8 Register.POLARITY-INVERSION-PORT-1 0x00
    registers_.write-u8 Register.CONFIGURATION-PORT-0 0xff
    registers_.write-u8 Register.CONFIGURATION-PORT-1 0xff

class Pin:
  static LOW ::= 0
  static HIGH ::= 1

  ioex_/PI4IOEX
  pin_/int
  direction_/int

  constructor ioex/PI4IOEX pin/int --direction/int=Direction.IN --pull-up-down/int=PullUpDown.DISABLED:
    assert: pin >= 0 and pin <= 15
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
    if direction == Direction.OUT and pull-up-down != PullUpDown.DISABLED:
      throw "Pull-up-down cannot be set for output pin."

  on:
    if direction_ == Direction.IN:
      throw "Pin is set to input, cannot be set to high."
    ioex_.write-pin pin_ HIGH

  off:
    if direction_ == Direction.IN:
      throw "Pin is set to input, cannot be set to low."
    ioex_.write-pin pin_ LOW

  value -> int:
    return ioex_.read-pin pin_
  
  direction direction/int:
    assert: direction == Direction.OUT or direction == Direction.IN
    ioex_.set-direction pin_ direction

  pull-up-down pull-up-down/int:
    if direction_ == Direction.OUT:
      throw "Pin is set to output, cannot set pull-up-down."
    assert: pull-up-down == PullUpDown.PULL-UP or pull-up-down == PullUpDown.PULL-DOWN or pull-up-down == PullUpDown.DISABLED
    if pull-up-down == PullUpDown.DISABLED:
      ioex_.enable-pull-up-down pin_ false
    else:
      ioex_.enable-pull-up-down pin_ true
      ioex_.pull-up-down pin_ pull-up-down