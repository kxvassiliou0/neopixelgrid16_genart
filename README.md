# Generative Art with NeoPixel Matrix and Serial Communication
This repository contains both an Arduino sketch and a Processing sketch working together to create generative art displayed on a NeoPixel matrix (16x16 grid). The Processing sketch produces the canvas and imagery, while the Arduino program converts it into data understandable by the NeoPixel grid.

## Arduino Sketch
Designed to receive colour data from the Processing sketch over a serial connection and display it on the NeoPixel hardware.

## Processing Sketch
Generates a canvas with a grid of binary cells transitioning between colour palettes.

## Dependencies
  * [Adafruit NeoPixel Library for Arduino](https://github.com/adafruit/Adafruit_NeoPixel)
