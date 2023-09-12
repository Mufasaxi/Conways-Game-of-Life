int[][] cells; //<>//
int[][] tempCells;
int[][] nextCells = null;
int cols;
int rows;
int resolution = 5;
boolean paused = false;


void setup() {
  size(1000, 800);
  cols = floor(width/resolution);
  rows = floor(height/resolution);

  cells = new int[cols][rows];
  tempCells = new int[cols][rows];

  // Setting up initial grid
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      cells[i][j] = floor(random(2));
    }
  }
}

void draw() {
  background(0);
  
  // Creating grid
  for (int i = 0; i < cols; i++) {
    int k = i * resolution;
    fill(40);
    rect(k, 0, 2, height);    
  }
  for (int i = 0; i < cols; i++) {
    int k = i * resolution;
    fill(40);
    rect(0, k, width, 2);    
  }

  // Creating white squares for cells that are 1s
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = i * resolution;
      int y = j * resolution;
      if (cells[i][j] == 1) {
        fill(255);
        stroke(0);
        rect(x, y, resolution, resolution);
      }
    }
  }

  // Creating top bar for controls
  // Background
  fill(100);
  rect(0, 0, width, 50);

  // Pause / Start
  fill(120);
  rect(10, 10, 25, 25);
  
  //fill(0);
  //textSize(25);
  //text("P", 15, 30); // REPLACE THIS WITH TRIANGLE AND TWO RECTANGLES FOR RESUME PAUSE

  // Generate
  fill(120);
  rect(45, 10, 25, 25);
  
  fill(0);
  textSize(25);
  text("G", 50, 30);

  // Clear
  fill(120);
  rect(80, 10, 25, 25);
  
  fill(0);
  textSize(25);
  text("C", 85, 30);

  // Pausing and unpausing simulation
  if (paused) {
    fill(0);
    // Pause symbol
    rect(16,14, 5,16);
    rect(23, 14, 5, 16);
    // Changing state of clicked rects
    if (mousePressed) {
      fill(0, 255, 0);
      int clickedX = (mouseX/resolution) * resolution; // To get the x and y of the rect being clicked
      int clickedY = (mouseY/resolution) * resolution;

      int i = clickedX / resolution;
      int j = clickedY / resolution;

      cells[i][j] = 1;


      if (clickedY > 50) {
        rect(clickedX, clickedY, resolution, resolution);
      }
    }
  } else {
    fill(0);
    // Resume symbol
    triangle(16,14, 16,30, 30,22);
    gameLogic();
  }
}

void gameLogic() {
  nextCells = new int[cols][rows]; // not memory efficient since new array is created each cycle

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int state = cells[i][j];
      int neighbours = countNeighbours(cells, i, j);

      // Any living cells with fewer than 2 or more than 3 neighbours dies
      if (state == 1 && (neighbours < 2 || neighbours > 3)) {
        nextCells[i][j] = 0;
      }
      // Any dead cell with 3 neighbours becomes alive
      else if (state == 0 && (neighbours == 3)) {
        nextCells[i][j] = 1;
      }
      // All other cells remain unchanged
      else {
        nextCells[i][j] = state;
      }
    }
  }

  cells = nextCells;
}

int countNeighbours(int[][] cells, int x, int y) {
  int sum = 0;
  for (int xOff = -1; xOff < 2; xOff++) {
    for (int yOff = -1; yOff < 2; yOff++) {
      int xIndex = (x + xOff + cols) % cols;
      int yIndex = (y + yOff + rows) % rows;
      sum += cells[xIndex][yIndex];
    }
  }

  sum -= cells[x][y];

  return sum;
}

void mousePressed() {
  // Start / Stop
  if (!((mouseX < 10) || (mouseX > 35) || (mouseY < 10) || (mouseY > 35)) && mousePressed) {
    paused = !paused;
  }

  // Generate
  if (!((mouseX < 45) || (mouseX > 70) || (mouseY < 10) || (mouseY > 35)) && mousePressed) {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        cells[i][j] = floor(random(2));
      }
    }
  }

  // Clear
  if (!((mouseX < 80) || (mouseX > 105) || (mouseY < 10) || (mouseY > 35)) && mousePressed) {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        cells[i][j] = 0;
      }
    }
  }
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      fill(0, 233, 0);
      rect(300, 300, 300, 300);
    }
  }
  // Start / Stop
  if (key == ' ') {
    paused = !paused;
  }
  
  // Generate
  if ((key == 'g' || key == 'G') && (paused)) {
    println("generate");
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        cells[i][j] = floor(random(2));
      }
    }
  }
  
  // Clear
  if ((key == 'c' || key == 'C') && (paused)) {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        cells[i][j] = 0;
      }
    }
  }
}
