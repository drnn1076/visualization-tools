//  Timeline project includes the following four files:
//  timeline_skeleton.pde, time_line.pde, timeline-items.xml, and timeline-items.xsd

/*  timeline_skeleton.pde and time_line.pde 
    Copyright (C) 2013  Ricardo Cedeño Montaña. 
    Humboldt-Universität zu Berlin. Institute of Cultural History and Theory
    rcedenom[at]pktweb[dot]com / cemontar[at]hu-berlin[dot]de
    http://pktweb.com, http://drnn1076.pktweb.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>. -->

    Last update on 27 May 2013. Ricardo Cedeño Montaña.

*/

import processing.pdf.*;

XMLElement myXml;
PFont regular;

// Identification of the timelime
String title = ""; //add a title between the "".
String subtitle = "";//add a subtitle between the "".
String author = "";//add your name between the "".
String afiliation1 = "";//add an institution between the "".
String wYear = "";//add a date between the "".


// Period of time covered.
// Substract one year at the beginning and add one to the end. 
// E.g. Period 1880- 2000 = 1879 and 2001.
// This range should include all the years mentioned in the xml data file, 
// otherwise an error will be raised.
int begin = 1869;
int end = 1956;  

// Leading affects the space for each year. If it is too small the font size of
// the years should be adjusted accordingly. 
// If the period is greater than 120 years, the leading should be reduced and 
// the size of the sketch should be incresed. 
// The shorter and crowder the period, the bigger the leading. 
// The larger the period, the smaller the leading.
int leading = 15;
// Set the width of the rectabgle that marks the item on the timeline.
int rectangleWidth = leading;
// Set the timeline width
int timelineWidth = 50;

int timeSpan = end-begin; // Number of years covered.
int fScale = 2; // Scale for the rectangles and lines of scale

void setup(){
  //Dimensions in pixels. size(1000, 1536) = 352x541mm. 
  //As a reference an A2 = 420x594mm, 1191x1684px.
  //It produces a vector based pdf saved where the sketch is located.
  size(1000, 1536);//, PDF, "filename.pdf");
  background(255);// White
  smooth();
  
  myXml = new XMLElement(this, "timeline-items.xml");//Locates the xml file.
  regular = loadFont("URWGothicL-Book-48.vlw");//Font type.

  // Include label.
  label();

  // Include the timeline.
  pushMatrix();
  translate(width/2, 150);// This locates the timeline on the space
  //Call the time_line sketch.
  timeLine(begin, end); 
  
  
  //Call a dictionary(HashMap) with each year and its horizontal position.
  HashMap yPos = yearPositions();
  //How many items have the xml file? 
  int nodes = myXml.getChildCount();
  int[] itemYears = new int[nodes];//This array stores all years where there is an item.
  
  for(int i=0; i<nodes; i++){  
    XMLElement item = myXml.getChild(i);    
    // Capture the data of each item from the XML.
    String itemName = item.getChild("name").getContent();
    String itemYear = item.getChild("date").getChild("year").getContent();
    String itemInfo = item.getChild("info").getContent();
    // Populate the itemYears array.
    itemYears[i]= int(itemYear); 
    // Selects the corresponding position from the HashMap.
    int posY = (Integer)yPos.get(itemYears[i])-(leading);
    
    // Call function to locate the item on the timeline.
    rectangle(itemName, itemYear, posY, itemInfo);
  }
  popMatrix();
  println ("Save PDF file: done!");
}  

// This stores temporally the amount of items for each year.
// Initially it is empty.
ArrayList storage = new ArrayList();

void rectangle(String iName, String iYear, int posY, String iInfo){
  // Generate a rectangle for each item.
  // Its position is the year assign to the item.
  int num = 0; //Variable to adjust the position of the format each year.
  noStroke(); // Rectangle style: no stroke
  fill(0); // Rectangle style: fill colour black
  // Check if the item year is on the list.
  // If not there, clear the list, add the year, 
  //and assign the lastindexof the year to num
  if (storage.contains(int(iYear))==false){
    storage.clear();
    storage.add(int(iYear));
    num = storage.lastIndexOf(int(iYear));
  }else{//if there, add the year, and assign the lastindexof the year to num
    storage.add(int(iYear));
    num = storage.lastIndexOf(int(iYear));
  }
  
  // Draw each rectangle adjusting its position with var num
  rect(timelineWidth/2, (posY-(rectangleWidth*num)+3), rectangleWidth/3,rectangleWidth/3); 
  
  // Generate labels for each format.
  fill(80);// Grey
  textFont(regular, 14);// Font size: 14pts
  textAlign(LEFT);
  text(iName, timelineWidth/2+rectangleWidth, posY-(leading*num)+rectangleWidth/3);
  
} 

void label(){
  //Header
  //Title
  int labelsLeading = 18;
  fill(0); // Black
  textFont(regular, 24); // Font size: 24pts
  textAlign(CENTER);
  text(title, width/2, labelsLeading*3); //(Content, vertical position, horizontal position)
  textFont(regular, 18); // Font size: 18pts
  textAlign(CENTER);
  text(subtitle, width/2, labelsLeading*4); //(Content, horizontal position, vertical position)
  
  //Footer
  //Author
  textFont(regular, 12); //Font size: 10pts
  textAlign(CENTER);
  text(author, width/2, height-(labelsLeading*4)); //(Content, horizontal position, vertical position)
  //afiliation
  textFont(regular, 12); //Font size: 10pts
  textAlign(CENTER);
  text(afiliation1, width/2, height-(labelsLeading*3)); //(Content, horizontal position, vertical position)
  //year
  textFont(regular, 12); //Font size: 10pts
  textAlign(CENTER);
  text(wYear, width/2, height-(labelsLeading*2)); //(Content, horizontal position, vertical position)
  
}




