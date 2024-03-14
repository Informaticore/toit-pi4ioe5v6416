class Register:
  static INPUT_PORT_0 ::= 0x00
  static INPUT_PORT_1 ::= 0x01
  static OUTPUT_PORT_0 ::= 0x02
  static OUTPUT_PORT_1 ::= 0x03
  static POLARITY_INVERSION_PORT_0 ::= 0x04
  static POLARITY_INVERSION_PORT_1 ::= 0x05
  static CONFIGURATION_PORT_0 ::= 0x06
  static CONFIGURATION_PORT_1 ::= 0x07
  static OUTPUT_DRIVE_STRENGTH_REGISTER_0_0 ::= 0x40
  static OUTPUT_DRIVE_STRENGTH_REGISTER_0_1 ::= 0x41
  static OUTPUT_DRIVE_STRENGTH_REGISTER_1_0 ::= 0x42
  static OUTPUT_DRIVE_STRENGTH_REGISTER_1_1 ::= 0x43
  static INPUT_LATCH_REGISTER_0 ::= 0x44
  static INPUT_LATCH_REGISTER_1 ::= 0x45
  static PULL_UP_DOWN_ENABLE_REGISTER_0 ::= 0x46
  static PULL_UP_DOWN_ENABLE_REGISTER_1 ::= 0x47
  static PULL_UP_DOWN_SELECTION_REGISTER_0 ::= 0x48
  static PULL_UP_DOWN_SELECTION_REGISTER_1 ::= 0x49
  static INTERRUPT_MASK_REGISTER_0 ::= 0x4A
  static INTERRUPT_MASK_REGISTER_1 ::= 0x4B
  static INTERRUPT_STATUS_REGISTER_0 ::= 0x4C
  static INTERRUPT_STATUS_REGISTER_1 ::= 0x4D
  static OUTPUT_PORT_CONFIGURATION_REGISTER ::= 0x4F

class Level:
  static LOW ::= 0x00
  static HIGH ::= 0x01
  static ALL_LOW ::= 0x0000
  static ALL_HIGH ::= 0xFFFF

class Polarity:
  static ORIGINAL ::= 0x00
  static INVERTED ::= 0x01
  static ORIGINAL_ALL ::= 0x0000
  static INVERTED_ALL ::= 0xFFFF

class Direction:
  static OUT ::= 0x00
  static IN ::= 0x01
  static OUT_ALL ::= 0x0000
  static IN_ALL ::= 0xFFFF

class PullUpDown:
  static PULL_DOWN ::= 0x00
  static PULL_UP ::= 0x01
  static PULL_DOWN_ALL ::= 0x0000
  static PULL_UP_ALL ::= 0xFFFF
  static DISABLED ::= 0x00
  static DISABLE_ALL ::= 0x0000
  static ENABLE_ALL ::= 0xFFFF
