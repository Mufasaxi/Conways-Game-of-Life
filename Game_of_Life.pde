int[][] cells; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
int[][] tempCells;
int[][] nextCells = null;
int cols;
int rows;
int resolution = 5;
boolean paused = false;


void setup() {
  size(1000, 600);
  cols = floor(width/resolution);
  rows = floor(height/resolution);

  cells = new int[cols][rows];
  tempCells = new int[cols][rows];

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      cells[i][j] = floor(random(2));
    }
  }
}

void draw() {
  // Pausing and unpausing simulation
  if (paused) {
    noLoop();
  } else {
    loop();
  }
  
  background(0);

  // Creating white squares for cells that are 1s
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = i * resolution;
      int y = j * resolution;
      if (cells[i][j] == 1) {
        fill(255);
        stroke(0);
        rect(x, y, resolution, resolution);
        /*} else {
         fill(0);
         rect(x, y , resolution, resolution);*/
      }
    }
  }

  /*if (nextCells != null) {
    tempCells = nextCells;
    nextCells = cells;
    cells = tempCells;
    print("in if");
  } else {
    nextCells = new int[cols][rows];
    println("in else");
  }*/
  
  nextCells = new int[cols][rows];

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
  paused = !paused;
  if (!paused) {
    redraw();
  }
  println(paused);
}
