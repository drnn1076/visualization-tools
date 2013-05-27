// Generate a list of years
int[] allYears;
int[] allYears(){  
  allYears = new int[(end - begin)+1];
  for (int i=0; i<=(allYears.length-1); i++){
    allYears[i]= i + begin;
  }
  return allYears;
}

// Generate a list of positions in Y for each year.
int[] listPosY;
int[] listPosY(){

  listPosY = new int[(end - begin)+1];
  factorDisplacementYear = 0;  //Reset the factor for each call of this function.
  for ( int i=0; i<=(listPosY.length-1); i++){ //Call the factor of displacement.
    listPosY[i] = (i*leading)+(leading*factorDisplacementYear(allYears[i]));
  }
  return listPosY;
}

//Generate a HashMap (dictionary). The key = year, the value is the x position on the timeline.
HashMap yearPositions;
HashMap yearPositions(){
  allYears();
  HashMap yearPositions = new HashMap(allYears.length); 
  for (int i=0; i<allYears.length; i++){
    yearPositions.put(allYears[i], listPosY[i]);
  } 
  return yearPositions;
}

// Check how many items there are for each year.
int factorDisplacementYear = 0;
int factorDisplacementYear(int pYear){
  int nodes = myXml.getChildCount();
  String tYear = str(pYear);
  int numItemsThatYear = 0;
  for (int j=0;j<nodes;j++){
     if (myXml.getChild(j).getChild("date").getChild("year").getContent().contains(tYear)){
        numItemsThatYear += 1; 
      }
    }
    // if there are more than one items then adjust the timeline accordingly.
    if (numItemsThatYear>1){
          factorDisplacementYear += (numItemsThatYear-1);
     } 
    
  return factorDisplacementYear;
}


void timeLine(int begin, int end){
  myXml = new XMLElement(this, "timeline-items.xml");
  int nodes = myXml.getChildCount();
  ArrayList itemYears = new ArrayList(); //Array to store all years with an item.
  
  for(int i=0; i<nodes; i++){  
    XMLElement item = myXml.getChild(i);    
    // Capture the data from the XML.
    String iYear = item.getChild("date").getChild("year").getContent();
    itemYears.add(int(iYear)); // Populate the array itemYears.
  }
 
  textFont(regular);
  textAlign(CENTER);

  for (int yNumber=0; yNumber<(end-begin); yNumber++){
    // List all years
    int aYear = allYears()[yNumber];
    // Get postions for each year
    int posY = listPosY()[yNumber];
    //If that year has an item, set fill to black and font size to 14pts.
    if (itemYears.contains(aYear)){
      fill(0);
      textSize(14);
    }else{// If not, set fill to grey and font size to 12pts.
      fill(200);
      textSize(12);
    }

    // Write the text of the year
    if (yNumber>0){
    text(str(aYear), 0, posY);
    }
    
    //  lines
    stroke(200);// Stroke colour: grey
    line(-timelineWidth/2,(posY)+3, timelineWidth/2,(posY)+3);
    line(timelineWidth/2, yNumber+3, timelineWidth/2, (posY+3));
    line(-timelineWidth/2, yNumber+3, -timelineWidth/2, (posY+3));
  }

}



