class Block{
  //x and y position of each block in maze
  int x;
  int y;
  //row and column Number of each Block
  int row;
  int col;
  // Variable to check if Block has been visited by DFS Algorithm
  boolean visitedByMaze = false;
  boolean backtracked = false;
  // denote the walls of Block , if true it means a wall exist
  boolean[] walls = {true, true, true,true};
  //List of Neighbors of each Block before the creation of a maze
  ArrayList<Block> neighbors = new ArrayList<Block>();
  
  //Search Algorithms variables
  boolean visitedBySearchAlgo = false;
   //List of neighbors of a Block After the Creation of a Maze i.e if a wall doesn't exist it is a neighbor
  ArrayList<Block> mazeNeighbors = new ArrayList<Block>();
  // distance of Block from start point
  float g = 100000000000.0;
  //Hueristic distance till Goal Block (Manhattan Distance)
  float h = 100000000000.0;
  //sum of g and h
  float f; 
  //Previous Node in Searched Path
  Block prev;
  //constructor
  Block(int colNo, int rowNo){
   
    x = rowNo * size;
    y = colNo * size;
    row = rowNo;
    col = colNo;
  }
  // method to Visually Create Each Block on Screen
  void show(){
   // this method creates the wall of Block if corresponding entry in walls array is true    
    if(walls[0]){
     line(x,y,x+size,y); //top wall
    }
    if(walls[1]){
     line(x+size,y,x+size,y+size); //right wall
    }
    if(walls[2]){
     line(x+size,y+size,x,y+size); //bottom wall
    }
    if(walls[3]){
     line(x,y+size,x,y); //left wall
    }
    //changing the color of Block if visited by DFS
    if(visitedByMaze ){
      noStroke();
      fill(255,50,255,95);
      rect(x,y,size,size);
      stroke(0);
    }
  }
  
  //Method to populate Neighbors array before implementing DFS
  void addNeighbors(){
    if(row>0){
      neighbors.add(blocks[col][row-1]);
    }
    if(col < cols-1){
      neighbors.add(blocks[col+1][row]);
    }
    if(row<rows-1){
      neighbors.add(blocks[col][row+1]);
    }
    if(col>0){
      neighbors.add(blocks[col-1][row]);
    }
    
  }
  //method to Add neighbors of a Block in the maze
   void addMazeNeighbors(){
    if(!walls[3]){
          mazeNeighbors.add(blocks[col][row-1]);
    }
    if(!walls[2]){
        mazeNeighbors.add(blocks[col+1][row]);
    }
    if(!walls[1]){
           mazeNeighbors.add(blocks[col][row+1]);
    }
    if(!walls[0]){
           mazeNeighbors.add(blocks[col-1][row]);
    }
  }
  
  //this method return true if a Block has neighbor not visited by DFS
  boolean hasUnvisitedNeighbor(){
    for(Block neighbor : neighbors){
      if(!neighbor.visitedByMaze){
        return true;
      }
    }
    return false;
  }
  
  // choose a random neighbor of a given block
  Block pickRandomNeighbor(){
    Block nbr = neighbors.get(floor(random(0,neighbors.size())));
    int i=1;
    while(nbr.visitedByMaze){
      if(i==4){break;}
      nbr = neighbors.get(floor(random(0,neighbors.size())));
      i++;
    }
    nbr.visitedByMaze = true;
    
    return nbr;
  }
 
  // draw a colored rectangle on a Block
void makeRect(int r, int g, int b){
  noStroke();
  fill(r,g,b);
  rect(x,y,size,size);
  stroke(0);
}
// draw a Line on Block
void makeLine(Block to,int r, int g, int b){
  strokeWeight(7);
  stroke(r,g,b);
  int x1= x+size/2;
  int y1 = y+size/2;
  int x2 = to.x + size/2;
  int y2 = to.y +size/2;
  line(x1,y1,x2,y2);
  strokeWeight(4);
  stroke(0);
}
    
      
}
