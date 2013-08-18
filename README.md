basic-nchannel-scope
====================

Use your Arduino's analog pins to stream serial data to your PC with a 1-8 channel graph in Processing.

Example Output
--------------

![Sample 8 channel graph](https://raw.github.com/xigme/basic-nchannel-scope/master/example.png "Sample 8 channel graph")

Quickstart
----------

1. Copy the "Arduino" folder to your Arduino sketches
2. Copy the "Processing" folder to your Processing sketches
3. Connect your Arduino by USB
4. Open the Arduino sketch and upload to the chip
5. Open the Processing sketch and run it
6. Watch live data!

Configuring the Arduino sketch
------------------------------

There are some configurable options at the top of the Arduino sketch:

```
// List the analog pins to be monitored
int analog_pins[] = {A0, A1, A2, A3, A4, A5};

// Delay (ms) between reading each analog pin
int pin_delay = 20;

// Delay (ms) between each loop of pins
int loop_delay = 0;

// LED ouput pin (data RX status)
int led_pin = 13;
```

Configuring the Processing sketch
---------------------------------

You don't need to change this file when changing the analog pins to monitor on the Arduino (except, perhaps, updating the labels)

```
// Run in full-screen mode (detects resolution)
boolean screen_fullscreen = false;

// These values are ignored if full screen is enabled
int screen_x = 722;
int screen_y = 600;

// Background color
int screen_bg_color[] = { 15, 15, 15 };

// Typography
String font_family = "Bitstream Vera Sans Mono";
int font_size = 14;
boolean font_smoothing = false;

// Colors for pin graph lines - example colors from colourlovers.com
int pin_colors[][] = {
  {4,131,181},    // Rayned Upon by QueenNatsu
  {253,139,4},    // Peachy Orange by ohmydammit
  {127,15,196},   // Shade of Purple by pinkruby.abbate
  {231,187,140},  // A Good Hug by batspit
  {241,60,13},    // Tomato Decor by American Women
  {160,139,12}    // Carrots and Stem by kirei
};

// Labels for each pin
String pin_labels[] = {
  "A0",
  "A1",
  "A2",
  "A3",
  "A4",
  "A5"
};
```

Troubleshooting
---------------

### Cannot receive data on serial port
Maybe the wrong port is selected. When the Processing sketch first runs, it will output a list of serial (COM) ports to the debug console. By default my script chooses number 1 but you may want a different one. Update the COM port on line 73 of the Processing sketch.

