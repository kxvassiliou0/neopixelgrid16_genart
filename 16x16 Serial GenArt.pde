import processing.serial.*;

Serial myPort; // Create a Serial object

int cols, rows;
int[][] binaryGrid;
int cellSize = 50;
int updateInterval = 1000;
int transitionDuration = 1000; // Transition duration in milliseconds

color backgroundColor = #111111; // Dark background color

color[][] palettes;
int currentPaletteIndex = 0;
int lastUpdateTime = 0;

void setup() {
  size(800, 800);
  cols = 16;
  rows = 16;
  binaryGrid = new int[cols][rows];
  frameRate(30);
  initializeGrid();
  background(backgroundColor);
  generateRandomPalettes();
  // Find and open the serial port (adjust the index [0] if needed)
  String[] portNames = Serial.list();
  if (portNames.length > 0) {
    String portName = portNames[0];
    myPort = new Serial(this, portName, 115200);
  } else {
    println("No serial ports found!");
  }
}

void draw() {
  int currentTime = millis();
  float transitionFraction = map(currentTime - lastUpdateTime, 0, transitionDuration, 0, 1);

  if (transitionFraction >= 1) {
    // Switch to the next color palette
    currentPaletteIndex = (currentPaletteIndex + 1) % palettes.length;
    lastUpdateTime = currentTime;
    transitionFraction = 0; // Reset the transition fraction
  }

  updateGrid();
  drawGrid(transitionFraction);
}

void initializeGrid() {
  // Fill the grid with random binary values (0 or 1)
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      binaryGrid[i][j] = int(random(2));
    }
  }
}

void updateGrid() {
  // Randomly update the values of the grid cells
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (random(1) < 0.5) {
        binaryGrid[i][j] = int(random(2));
      }
    }
  }
}

void drawGrid(float transitionFraction) {
  // Draw the grid with interpolated colors based on the transition fraction
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = i * cellSize;
      int y = j * cellSize;

      int colorIndexA = int(random(palettes[currentPaletteIndex].length));
      int colorIndexB = int(random(palettes[(currentPaletteIndex + 1) % palettes.length].length));

      color colorA = palettes[currentPaletteIndex][colorIndexA];
      color colorB = palettes[(currentPaletteIndex + 1) % palettes.length][colorIndexB];

      color interpolatedColor = lerpColor(colorA, colorB, transitionFraction);

      fill(interpolatedColor);
      if (binaryGrid[i][j] == 1) {
        rect(x, y, cellSize, cellSize);

        // Convert the color components to 0-255 range
        int r = int(red(interpolatedColor) * 255.0);
        int g = int(green(interpolatedColor) * 255.0);
        int b = int(blue(interpolatedColor) * 255.0);

        // Send color data to the Seeeduino Xiao over the serial port
        sendColorToSeeeduino(i, j, r, g, b);
      }
    }
  }
}

void generateRandomPalettes() {
  // Generate random colors for each palette
  palettes = new color[5][5]; // Assuming there are 5 palettes, each with 5 colors

  for (int i = 0; i < palettes.length; i++) {
    for (int j = 0; j < 5; j++) {
      palettes[i][j] = color(random(255), random(255), random(255));
    }
  }
}

void sendColorToSeeeduino(int col, int row, int r, int g, int b) {
  // Send color data to the Seeeduino Xiao over the serial port
  r = int(r*0.01);
  g = int(g*0.01);
  b = int(b*0.01);
  myPort.write(r); // Send the red component
  myPort.write(g); // Send the green component
  myPort.write(b); // Send the blue component
}

void mousePressed() {
  // Reset the grid to its initial state when the mouse is pressed
  initializeGrid();
}
