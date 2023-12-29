#include <Adafruit_NeoPixel.h>

#define LED_PIN 7
#define BUTTON_PIN 5 // The pin where the button is connected
#define LED_COUNT 256 // 16x16 NeoPixel matrix

Adafruit_NeoPixel matrix = Adafruit_NeoPixel(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);
bool generateColors = true;
bool pauseColors = false; // Flag to pause color generation
int brightnessValue = 10; // Set the initial brightness (0-255, 128 is half brightness)

void setup() {
  matrix.begin();
  matrix.setBrightness(brightnessValue); // Set the initial brightness
  matrix.show(); // Initialize all pixels to off
  pinMode(BUTTON_PIN, INPUT_PULLUP);
}

void loop() {
  // Check if there's incoming serial data
  if (generateColors && !pauseColors) {
    if (Serial.available() >= 5) {
      int col = Serial.read();
      int row = Serial.read();
      int r = Serial.read();
      int g = Serial.read();
      int b = Serial.read();

      int pixelIndex = row * 16 + col;
      matrix.setPixelColor(pixelIndex, r, g, b);
      matrix.show();
    }
  }

  // Check for button press to toggle pauseColors flag
  if (digitalRead(BUTTON_PIN) == LOW) {
    pauseColors = !pauseColors; // Toggle pauseColors flag
    delay(200); // Add a small delay to debounce the button
  }
}
