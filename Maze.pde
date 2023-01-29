int rows;
int cols;
//size of each Block
int size = 40;

//Array Representing all the blocks of a maze
Block[][] blocks;
//Current Block in DFS Algorithm
Block current;
// if Maze has been completely created
boolean mazeFinished = false;
//Stack to add Blocks for Depth first Algorithm
ArrayList<Block> stack = new ArrayList<Block>();

//global variables for searchh algorithm
Block startSearchBlock;
Block currentSearchBlock; // for highlighting the Current Block during A* Search
Block finalSearchBlock;
//Actual Shortest Path in maze
ArrayList<Block> actualPath = new ArrayList<Block>();
//All the Blocks where A* Algorithm has Visited
ArrayList<Block> searchPath = new ArrayList<Block>();
// Check Variable to skip iterations of Adding Maze Neighbors of each Block
boolean searchNeighborsAdded = false; 
//this set will contain all the Nodes which are Found by A* Algorithm 
ArrayList<Block> openSet = new ArrayList<Block>();
//if path till Goal Node is found set it to true
boolean pathFound = false;

//global arrays for bonus 
Block [] bonus = new Block[12];
boolean [] bonuses = new boolean[12];


// this method runs only one time in Processing Library 
//purpose of it is to setup the required Structure
void setup(){
     //screen Size (Width,Height)
     size(600,600 );
     //total rows and columns
     rows = height/size;
     cols = width/size;
     blocks = new Block[cols][rows]; 
     
     //inititalizing all the Nodes 
     for(int i=0;i<cols;i++){
       for(int j=0;j<rows;j++){
         blocks[i][j] = new Block(i,j);
       }
     }
     
     // Adding Neighbors of each Node
     for(int i=0;i<cols;i++){
       for(int j=0;j<rows;j++){
         blocks[i][j].addNeighbors();
       }
     }
     // starting Block of Maze creation DFS
     current = blocks[0][0];
     current.visitedByMaze = true;
    // Starting Block of A*
    startSearchBlock = blocks[0][0];
    //Goal Node
    finalSearchBlock   = blocks[cols-1][floor(random(0,rows-1))];
    if(finalSearchBlock == bonus[0] ){
      finalSearchBlock   = blocks[cols-1][floor(random(0,rows-1))];
             
    }
     
     //this determines how many times Draw function will run in a unit time
     //(means Speed of Program)
     frameRate(100);
}

//this method runs over and over again infinitely in this Library (Processing IDE)
void draw(){
   //if Maze is not created
  if(!mazeFinished){
    //set background
    background(0,255,255);
    strokeWeight(4);
    stroke(255,255,0);
    // Show all the Blocks over the Background 
     for(int i=0;i<cols;i++){
       for(int j=0;j<rows;j++){
         blocks[i][j].show();
       }
     }
      // highlighting the current Block which is being Visited by DFS 
      fill(193,50,193);
      rect(current.x,current.y,size,size);
      
     //implementation of DFS starts here
      
      if(current.hasUnvisitedNeighbor()){   
        // if current Block has any Unvisited Neighbor
        //pick any Random Neighbor of current Block
        Block nextCurrent = current.pickRandomNeighbor();
        // Add current Block to Stack 
        stack.add(current);
        // remove walls between current and its Randomly Picked Neighbor
        removeWalls(current,nextCurrent);
        // Make the Random Neighbor current 
        current = nextCurrent;
        }
        // if Current Block do not has any Unvisited Neighbor 
       else if(stack.size()>0){ //and Stack has any Node present
        current = stack.get(stack.size()-1); //pop entry from Stack
        current.backtracked = true;
          stack.remove(current);
       }
       else if(!current.backtracked){
        //pick any Random Neighbor of current Block
        Block nextCurrent = current.pickRandomNeighbor();
        // remove walls between current and its Randomly Picked Neighbor
        removeWalls(current,nextCurrent);
        // Make the Random Neighbor current 
        current = nextCurrent;
        }
       // if Stack has no Node left
       else{
         print("Maze Done");
         mazeFinished =  true; //Mark the maze as Finished
         //scattering bonus boxes in maze 
         bonus[1] = blocks[cols/2][rows/2];
         bonus[2] = blocks[1][rows/2];
         bonus[3] = blocks[(cols/2)-1][1];
         bonus[4] = blocks[(cols/2)+1][rows-2];
         bonus[5] = blocks[(cols-1)-2][rows-2];
         bonus[6] = blocks[cols/4][(rows/2) +3];
         bonus[7] = blocks[cols-1][2];
         bonus[0] = blocks[cols-2][rows/2];
       }
  } // DFS Ends here (A maze has been Created Randomly)
  
  //A* Search Algorithm Starts Here
  else{ 
       strokeWeight(4);
       stroke(255,255,0);
       background(0,255,255);
       //Highlighting the Start and End Search Block of maze
      startSearchBlock.makeRect(255,0,0);
      finalSearchBlock.makeRect(255,0,0);
      
      //Creating a Blue rectangle on each Bonus Block
      for(int i=0;i<8;i++){
        if(bonus[i] !=null){
          bonus[i].makeRect(0,0,255);
        }
      }
        // before implementing A* add neighbors of each Node in the Maze 
        // i.e if no wall exist between them
         if(!searchNeighborsAdded){ // this if will execute only once
           for(int i=0;i<cols;i++){
              for(int j =0; j<rows ;j++){
                blocks[i][j].addMazeNeighbors();
              }
           }
           //set  g and f value of Starting Node
           startSearchBlock.g =0;
           startSearchBlock.f = heuristic(startSearchBlock, finalSearchBlock);
           //Add Start Search Block to open set
           openSet.add(startSearchBlock);
           searchNeighborsAdded = true;  //all the neighbors in maze have been added
         } 
         //Now, While the Open set has any Node in it
         if(openSet.size()>0){
           //choose the one with Lowest F score
           currentSearchBlock = lowestFinOpenSet();
           
           // if the Block Chosen is our Goal Node
           if(currentSearchBlock == finalSearchBlock){
             pathFound = true; //mark the path found as true
             // And Store all the nodes in path to an array using this function
             constructActualPath();  
             // Highlight the Found path with help of a Line
             for(int i=0;i<actualPath.size()-1;i++){
               actualPath.get(i).makeLine(actualPath.get(i+1),255,0,0);
             }
             
             startSearchBlock.makeRect(255, 0, 0);
             finalSearchBlock.makeRect(255, 0, 0);
             noLoop(); //end the program
           }
           // if the Node selected from open set is not the Goal Node 
           //then do the following
           if(!pathFound){
            
             openSet.remove(currentSearchBlock); // remove it from openset
            
             // Iterate over all the neighbors of Node selected from openset
             for(Block nbr : currentSearchBlock.mazeNeighbors){
               
                //compute the distance of neighbor from start Block if we came through Search Block selected from openset
                float temp = currentSearchBlock.g +1;
                // if we can reach the neighbor in smaller distance than already present g value
                if(temp < nbr.g){
                   nbr.prev = currentSearchBlock; //update the previous of that neighbor
                   nbr.g = temp; //update g value to make it smallest
                   //compute new f value of that neighbor
                   nbr.f = nbr.g + heuristic(nbr,finalSearchBlock);
                   // if that neighbor is not present in openset add it there
                   if(!openSet.contains(nbr)){
                    openSet.add(nbr);
                   }
                 } 
                 
             // if search Algorithm has visited any Bonus Block then mark that as true
             for(int i=0; i<8;i++){
                if(currentSearchBlock == bonus[i] ){
                 bonuses[i] = true;
                }
             }
                  // Add the Block Currently Being visited to the SearchedPath Array
                 constructSearchPath();
                 
                 // Highlight all the Bonus Blocks if they are visited by A* Algorithm
                  for(int j=0; j<searchPath.size()-1; j++){
                    if( searchPath.get(j)!=bonus[0] &&searchPath.get(j)!=bonus[1]
                        && searchPath.get(j)!=bonus[2] && searchPath.get(j)!=bonus[3]
                        && searchPath.get(j)!=bonus[4]  && searchPath.get(j)!=bonus[5]
                        && searchPath.get(j)!=bonus[6]  && searchPath.get(j)!=bonus[7]){
                          
                          searchPath.get(j).makeRect(255,255,0);
                        }
                  }
                  startSearchBlock.makeRect(255,0,0);
                  finalSearchBlock.makeRect(255,0,0);
              }  
           }
               for(int j=0;j<8;j++){
                   if(bonuses[j]){
                   bonus[j].makeRect(0,255,0);
                  }
               }
               
               for(int i=0;i<cols;i++){
                   for(int j=0;j<rows;j++){
                       blocks[i][j].show();
                    }
               }
         } else if(pathFound){
                noLoop(); 
         }
  }
}

// method to remove walls while maze creation
void removeWalls(Block current,Block next){
  int  x = current.row - next.row;
  int y = current.col-next.col;
  
  if(x == -1){ // if the next block is to the right
  //remove right wall of current block
    current.walls[1] = false;
    // and left wall of next block
    next.walls[3] = false;
  }
  else if(x==1){  // if the next block is to the left
    current.walls[3] = false;
    next.walls[1] = false;
  }
  
  if(y==-1){ // if next block is below current
    current.walls[2] = false;
    next.walls[0] = false;
  }
  else if(y==1){ //if above current
    current.walls[0] = false;
    next.walls[2] = false;
  }
}

// Calculate hueristic value of Given Block  using distance formula
float heuristic(Block start, Block end){
  return  dist(start.row,start.col,end.row,end.col);
}

// iterate the Openset and return the Node with lowest F value (works as priority queue)
Block lowestFinOpenSet(){
  Block lowestFScore = openSet.get(0);
  for(Block b : openSet){
    if(b.f<lowestFScore.f){
      lowestFScore = b;
    }
  }
  return lowestFScore;
}

void constructSearchPath(){
  Block current = currentSearchBlock;
  searchPath.add(current);
   while(current != startSearchBlock){
    searchPath.add(current);
    current = current.prev;
  }
}

void constructActualPath(){
  Block current = currentSearchBlock;
  actualPath.add(current);
  // populate the array by adding previous of each entry 
  while(current != startSearchBlock){
    actualPath.add(current);
    current = current.prev;
  }
}
