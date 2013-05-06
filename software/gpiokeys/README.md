# GPIO Keyboard Daemon for the Raspberry Pi

This daemon uses the Linux [uinput](http://thiemonge.org/getting-started-with-uinput)
subsystem to simulate a keyboard using push buttons attached to the GPIO pins. The
daemon expects the pins to be pulled high in the **normal** state and to go low
when the button is depressed. It simulates a USB keyboard and will generate
*key up* and *key down* events accordingly.

The daemon uses a configuration file to specify the GPIO pins to monitor and the
key codes to generate when the GPIO pin changes state.
