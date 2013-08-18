
/*

  THE ARDUINO SKETCH
  (requires accompanying Processing code)
  
  Basic n-Channel Oscilloscope
  by @xigme
  
  This program is free software: you can redistribute it and/or modify it under the terms of the
  GNU General Public License as published by the Free Software Foundation, either version 3 of the
  License, or (at your option) any later version.

*/


/*
  OPTIONS
*/

// List the analog pins to be monitored
int analog_pins[] = {A0, A1, A2, A3, A4, A5};

// Delay (ms) between reading each analog pin
int pin_delay = 20;

// Delay (ms) between each loop of pins
int loop_delay = 0;

// LED ouput pin (data RX status)
int led_pin = 13;


/*
  INTERNAL VARIABLES
*/

// LED status (for toggling)
boolean led_pin_status;




void setup()
{
  // Initialise serial port to host
  Serial.begin( 9600 );
  
  // Initialise LED output pin
  pinMode( led_pin, OUTPUT );
}



void loop()
{
  // Build an output string of values
  String output;
  
  // Loop through list of analog pins
  for ( int analog_pin_key = 0; analog_pin_key < sizeof(analog_pins) / sizeof(int); ++analog_pin_key )
  {
    // Read the value from the chosen pin
    int val = analogRead( analog_pins[analog_pin_key] );
    
    // Append it to the output string
    output += String( val ) + ',';
    
    // Delay between pin readings
    delay( pin_delay );
  }
  
  // Remove unwanted "," from end of output string
  output = output.substring( 0, output.length() - 1 );
  
  // Output to serial device
  Serial.println( output );
  
  // Delay between cycles
  delay( loop_delay );
}


// Triggered when we receive a byte of data from the host
void serialEvent()
{
  // Toggle status LED
  led_pin_status = !led_pin_status;
  digitalWrite( led_pin, led_pin_status );
}
