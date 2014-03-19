//  Timeline project includes the following four files:
//  timeline_skeleton.pde, time_line.pde, timeline-items.xml, and timeline-items.xsd

//This program takes a XML file and produces a PDF file.

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
    
    Last update on 19 March 2014. Ricardo Cedeño Montaña
    Reason of the update: code cleaning and documentation.

*/

import processing.pdf.*;

// 1. 
// Introduce the size of the paper
// As a reference: A4= 210x297, A3 = 297x420, A2 = 420x594, A1= 594x841mm
int pageWidth= 594;//in mm
int pageHeight= 841;//in mm
// 2. 
// Introduce the period of time covered.
// This range should cover all the years mentioned in the xml data file, 
// otherwise an error will be raised.
int begin = 1865;
int end = 1942;  
// 3.
// Leading affects the space for each year. If it is too small the font size of
// the years should be adjusted accordingly. 
// If the period is greater than 120 years, the leading should be reduced and 
// the size of the sketch should be incresed. 
// The shorter and crowder the period, the bigger the leading. 
// The larger the period, the smaller the leading.
int leading = 25;
// Set the timeline width
int timelineWidth = 50;
//4.
// Set the typeface for the timeline.
// It should be in the data folder of the sketch.
PFont regular = createFont("URW Gothic L Book", 48, true);
//5.
//Give name of the xml file between quotes.
String xmlFile = "timeline-items.xml";
// 6.
//Jump to the label sketch to input the labels for the timeline


//The following calculations performed by the sketch automatically
float pageWidthInches = pageWidth/25.4;//to inches
float pageHeightInches = pageHeight/25.4;
float pageWidthPixels = pageWidthInches*72;//72dpi
float pageHeightPixels = pageHeightInches*72;
// Create XMl object
XML xml;
// Set the timespan covered
int timespan = end-begin; 
// Set the width of the rectabgle that marks the item on the timeline.
int rectangleWidth = leading;
// Scale for the rectangles and lines of scale
int fScale = 2; 

// Program

void setup(){
  //It produces a vector based pdf saved where the sketch is located.
  size(int(pageWidthPixels),int(pageHeightPixels), PDF, "filename.pdf");
  background(255);// White
  smooth();
  
  xml = loadXML(xmlFile);
  // Create array to store all years within the timespan with an item in the XML file 
  ArrayList yearsWithItem = new ArrayList(); //New empty array to store years with an item.
  XML[] items = xml.getChildren("item");
  for(int i=0; i<items.length; i++){      
    // Capture the data from the XML.
    String iYear = items[i].getChild("date").getChild("year").getContent();
    yearsWithItem.add(int(iYear)); // Populate the array itemYears.
  }
 println("Years with items:"+" "+ (yearsWithItem)); //output's control
  
  // Include label.
  label();

  // Change coordinates to locate the timelime in the centre of the page
  pushMatrix();
  translate(width/2, 150);// This locates the timeline on the space
  
  //Call the time_line sketch.
  //arguments: initial year, end year, and the array of years with items
  timeLine(begin, end, yearsWithItem); 
  
  
  //Call an instance of the dictionary(HashMap) with each year and its vertical position.
  HashMap yPos = yearPositions();
  
  //How many items have the xml file? 
  //Produce an array with each node in the XML data
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
    // Call function to locate the item on the timeline.
    locateDataInTimeline (itemName, itemYear, posY, itemInfo);
  }
  popMatrix();
  println ("Save PDF file: done!");
  println ("File saved as filename.pdf in the folder where this sketch is located");
}  

// This stores temporally the amount of items for each year.
// Initially it is empty.
ArrayList storage = new ArrayList();

void locateDataInTimeline(String iName, String iYear, int posY, String iInfo){
  // Generate a rectangle for each item.
  // Its position is the year assign to the item.
  int num = 0; //Variable to adjust the position of the format each year.
  noStroke(); // Rectangle style: no stroke
  fill(0); // Rectangle style: fill colour black
  // Check if the item year is on the list.
  // If not there, clear the list, add the year, 
  // and assign the lastindexof the year to num
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



