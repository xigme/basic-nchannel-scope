
/*

  THE PROCESSING SKETCH
  (requires accompanying Arduino code)
  
  Basic n-Channel Oscilloscope
  by @xigme
  
  This program is free software: you can redistribute it and/or modify it under the terms of the
  GNU General Public License as published by the Free Software Foundation, either version 3 of the
  License, or (at your option) any later version.

*/


/*
  LIBRARIES
*/

import processing.serial.*;



/*
  OPTIONS
*/

// Run in full-screen mode (detects resolution)
boolean screen_fullscreen = false;

// These values are ignored if full screen is enabled
int screen_x = 800;
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



/*
  INTERNAL VARIABLES
*/

int first_byte = 0;

Serial myPort;    // The serial port
int serial_port = 1;
int serial_baud = 9600;

int xPos = -1;     // Horizontal position of the graph

float pin_vals[] = { 0, 0, 0, 0, 0, 0 };

PFont font;




boolean sketchFullScreen()
{
  // Go full screen if configured
  return screen_fullscreen;
}



void setup()
{

  // Are we full screen?
  if ( screen_fullscreen )
  {
    // Override width/height with maximums
    screen_x = displayWidth;
    screen_y = displayHeight;
  }
  // Set canvas to desired width/height
  size( screen_x, screen_y );
  
  // Set fonts
  //font = createFont( font_family, font_size, font_smoothing );
  font = loadFont("BitstreamVeraSansMono-Roman-14.vlw");
  
  // List all the available serial ports
  println(Serial.list());
  
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[serial_port], serial_baud);
  
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
}


void draw()
{

  // everything happens in the serialEvent()

}

void serialEvent( Serial myPort )
{
  // Get string of data from Arduino
  String inString = myPort.readStringUntil('\n');
  
  // Make sure not blank
  if (inString != null)
  {
    if (first_byte == 0)
    {
      first_byte = 1;
    }
    else
    {
      // Trim off any whitespace
      inString = trim(inString);
      
      // Convert string to an array of pin ints
      float[] inBytes = float(split(inString, ','));
      
      if ( xPos == 0 )
      {
        draw_background( inBytes.length );
      }
      
      // Loop through array of pin values
      for (int inByte_key = 0; inByte_key < inBytes.length; ++inByte_key)
      {
        // Fetch pin value
        float val = inBytes[inByte_key];
        float val_volts = val * .0049;
  
        // Map value to y
        int y_each = screen_y / inBytes.length;
        int y0 = y_each * inByte_key;
        int y1 = y_each * (inByte_key + 1) - 1;
        float inByte = map( inBytes[inByte_key], 0, 1023, y1, y0);
        
        // Draw the line
        stroke( pin_colors[inByte_key][0], pin_colors[inByte_key][1], pin_colors[inByte_key][2], 128 );
        line( xPos - 1, pin_vals[inByte_key], xPos, inByte );
        
        // Draw value box
        stroke( 45, 45, 45, 255 );
        fill( 45, 45, 45, 255 );
        rect( 0, y0, 80, 20 );
        
        // Write out value
        textFont( font, font_size );
        fill( pin_colors[inByte_key][0], pin_colors[inByte_key][1], pin_colors[inByte_key][2], 255 );
        textAlign( RIGHT );
        text( nf( val_volts, 1, 3 ) + "v", 60, y0 + (font_size / 2) + 8 );
        
        // Remember value for next loop
        pin_vals[inByte_key] = inByte;
      }
  
      // Are we at the edge of the screen?
      if (xPos >= screen_x)
      {
        // Go back to start
        xPos = 0;
      }
      else
      {
        // Increment the horizontal position:
        xPos++;
      }
      
      // Write confirmation to Arduino
      myPort.write(32);
    }
  }
}


void draw_background( int channels )
{
  // Set background color
  background( screen_bg_color[0], screen_bg_color[1], screen_bg_color[2] );
  
  // How much y can we give each pin / channel?
  int y_each = screen_y / channels;
  
  // Loop through pins / channels
  for (int channel = 0; channel < channels; ++channel)
  {
    // Calculate min/max height for this channel
    int y0 = y_each * channel;
    int y1 = y_each * (channel + 1) - 1;
    
    // Draw lines for units (volts)
    int y_each_unit = y_each / 5;

    for (int i = 0; i < 5; i++)
    {
      stroke(50,50,50);
      line(0, y1 - ( y_each_unit * i ), screen_x, y1 - ( y_each_unit * i ));
      
      // Add unit value for line
      textFont( font, font_size );
      fill( 255 );
      textAlign( RIGHT );
      text( i, screen_x - font_size - 20, y1 - ( y_each_unit * i ) + (font_size / 2) );
    }
    
    // Draw line underneath channel graph
    stroke(100,100,100);
    line(0, y1, screen_x, y1);
    
    // Draw rectangle for channel label
    stroke( pin_colors[channel][0], pin_colors[channel][1], pin_colors[channel][2] );
    fill( pin_colors[channel][0], pin_colors[channel][1], pin_colors[channel][2] );
    rect( screen_x - 20, y0, screen_x, y1 );
    
    // Rotate/translate to write channel label
    pushMatrix();
    translate(screen_x - 15, y1 - ( (y1 - y0) / 2 ) );
    rotate(radians(90));
    textFont( font, font_size );
    textAlign( CENTER );
    fill( 255 );
    text( pin_labels[channel], 0, 0 );
    popMatrix();
  }
}
