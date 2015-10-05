//introduce variables and objects
PImage mapImage;
Table locationTable; //this is using the Table object
Table dataTable; //this is using the Table object
Table namesTable; //Table for Names
int rowCount;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;
float cdataMin = MAX_FLOAT;
float cdataMax = MIN_FLOAT;


//color[] colors = {#DEFFFF, #A0B8B8, #B8D4D4, #87EDED, #3D6B6B, #0D6B6B};
color[] colors = {#BD7938, #8D4421, #643001, #532700, #3A1C00, #120900};

//global variables assigned values in drawData()
float closestDist;
String closestText;
float closestTextX;
float closestTextY;

void setup() {
 size(1014,724);
  mapImage = loadImage("SF_map.png");

  //assign tables to object
  dataTable = new Table("pivotData.tsv"); //All in one table

  // get number of rows and store in a variable called rowCount
  rowCount = dataTable.getRowCount();
  //count through rows to find max and min values in random.tsv and store values in variables
  for (int row = 0; row< rowCount; row++) {
    //NZ - this was originally pointing to the sizes table.
    //get the value of the second field in each row (1) - NZ - Changed it to the 3rd
    float value = dataTable.getFloat(row, 2);
    //if the highest # in the table is higher than what is stored in the 
    //dataMax variable, set value = dataMax
    //NZ - This is just verification of size I think? 
    if (value>dataMax) {
      dataMax = value;
    }
    //same for dataMin
    if (value<dataMin) {
      dataMin = value;
    }
  }
}

void draw() {
  background(255);
  image(mapImage, 0, 0);

  closestDist = MAX_FLOAT;

//count through rows of location table, 
  for (int row = 0; row<rowCount; row++) {
    //assign id values to variable called id
    String id = dataTable.getRowName(row);
    //get the 2nd and 3rd fields and assign them to
    //NZ - changed it to 4 and 5 in the mega table
    float x = dataTable.getFloat(id, 4);
    float y = dataTable.getFloat(id, 5);
    //use the drawData function (written below) to position and visualize
    drawData(x, y, id);
  }

//if the closestDist variable does not equal the maximum float variable....
  if (closestDist != MAX_FLOAT) {
    fill(0);
    textAlign(LEFT);
    textSize(20);
    text(closestText, closestTextX, closestTextY);
  }
}

//we write this function to visualize our data 
// it takes 3 arguments: x, y and id
void drawData(float x, float y, String id) {
//value variable equals second field in row (NZ - 3rd)
  float value = dataTable.getFloat(id, 2);
  float colorData = dataTable.getFloat(id, 3);
  float radius = 0;
 // color colorData;
       if (colorData>cdataMax) {
      cdataMax = colorData;
    }
    //same for dataMin
    if (colorData<cdataMin) {
      cdataMin = colorData;
    }
   float colorValue = norm(colorData, cdataMin, cdataMax);  
  color between = lerpColor(#fffdef, #fb253a, colorValue);
  fill(between);
     

  
 //if the value variable holds a float greater than or equal to 0
  if (value>=0) {
    //remap the value to a range between 1.5 and 15
    radius = map(value, 0, dataMax, 5, 30); 
//    colorValue = colors[round(colorData)-1  ];
    //println(id+"\t"+round(colorData));
    //delay(1000);
    //and make it this color
  } else {
    //otherwise, if the number is negative, make it this color.
    radius = map(value, 0, dataMin, 1.5, 15);
    fill(#FF4422);
  }
 

  
  //make a circle at the x and y locations using the radius values assigned above
  ellipseMode(RADIUS);
  ellipse(x, y, radius, radius);

  float d = dist(x, y, mouseX, mouseY);

//if the mouse is hovering over circle, show information as text
  if ((d<radius+2) && (d<closestDist)) {
    closestDist = d;
    String name = dataTable.getString(id, 1);
    float importance = dataTable.getFloat(id, 3);
    closestText = name +"\n"+"Conversation count: "+round(value)+"\n"+"Importance: "+importance;
    closestTextX = 50;
    closestTextY = 50;
    //println(dataMin+"\t"+dataMax);
  }
}