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

    Created January 2013
    
    Last update on 11 June 2013. Ricardo Cedeño Montaña.
    Reason of the update: code update to Processing 2.0
    
    Last update on 26 September 2013. Ricardo Cedeño Montaña.
    Reason of the update: code to automatically set the size of the sketch.

*/

import processing.pdf.*;

// Calculate the size of the paper
// As a reference: A4= 210x297, A3 = 297x420, A2 = 420x594, A1= 594x841mm
int pageWidth= 594;//in mm
int pageHeight= 841;//in mm
float pageWidthInches = pageWidth/25.4;//to inches
float pageHeightInches = pageHeight/25.4;
float pageWidthPixels = pageWidthInches*72;//72dpi
float pageHeightPixels = pageHeightInches*72;


XML xml;
PFont regular;
// Period of time covered.
// Substract one year at the beginning and add one to the end. 
// E.g. Period 1880- 2000 = 1879 and 2001.
// This range should cover all the years mentioned in the xml data file, 
// otherwise an error will be raised.
int begin = 1870;
int end = 1940;  

// Leading affects the space for each year. If it is too small the font size of
// the years should be adjusted accordingly. 
// If the period is greater than 120 years, the leading should be reduced and 
// the size of the sketch should be incresed. 
// The shorter and crowder the period, the bigger the leading. 
// The larger the period, the smaller the leading.
int leading = 25;
// Set the width of the rectabgle that marks the item on the timeline.
int rectangleWidth = leading;
// Set the timeline width
int timelineWidth = 50;

int timeSpan = end-begin; // Number of years covered.
int fScale = 2; // Scale for the rectangles and lines of scale

void setup(){
  //It produces a vector based pdf saved where the sketch is located.
  size(int(pageWidthPixels),int(pageHeightPixels), PDF, "filename.pdf");
  background(255);// White
  smooth();
  
  xml = loadXML("timeline-items.xml");//Locates the xml file.
  regular = createFont("URW Gothic L Book", 48, true);//Font type.

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

  //Produce an array with each node in the XML data
  XML[] items = xml.getChildren("item");
  int[] itemYears = new int[items.length];//This array stores all years where there is an item.
  
  for(int i=0; i<items.length; i++){     
    // Capture the data of each item from the XML.
    String itemName= items[i].getChild("name").getContent();
    String itemYear = items[i].getChild("date").getChild("year").getContent();
    String itemInfo = items[i].getChild("info").getContent();
    // Populate the itemYears array.
    itemYears[i]= int(itemYear);
    // Selects the corresponding position from the HashMap.
    int posY = (Integer)yPos.get(itemYears[i])-(leading);
    //println(posY);    
    // Call function to locate the item on the timeline.
    rectangle (itemName, itemYear, posY, itemInfo);
  }
  popMatrix();
  println ("Save PDF file: done!");
  println ("File saved as filename.pdf in the folder where this sketch is located");
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
  rect(timelineWidth/2, ((posY+(leading/2))-(rectangleWidth*num)+3), rectangleWidth/3,rectangleWidth/3); 
  
  // Generate labels for each format.
  fill(80);// Grey
  textFont(regular, 14);// Font size: 14pts
  textAlign(LEFT);
  text(iName, timelineWidth/2+rectangleWidth, (posY+(leading/2))-(leading*num)+rectangleWidth/3);
  
} 



