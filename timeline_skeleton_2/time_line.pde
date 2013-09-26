
// Generate a list of years
int[] allYears;
int[] allYears(){  
  allYears = new int[(end - begin)+1]; // +1 to include the fisrt year.
  for (int i=0; i<=(allYears.length-1); i++){ //-1 cause it counts from 0
    allYears[i]= i + (begin);
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
  XML[] items = xml.getChildren("item");
  String tYear = str(pYear);
  int numItemsThatYear = 0;
  for (int j=0;j<items.length;j++){
    //Check whether the item's year is the same as the year being evaluated
     if (items[j].getChild("date").getChild("year").getContent().contains(tYear)){
        //if true add one to the numbers of items that year
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
  xml = loadXML("timeline-items.xml");
  //int nodes = xml.getChildCount();
  ArrayList itemYears = new ArrayList(); //Array to store all years with an item.
  
  XML[] items = xml.getChildren("item");
  for(int i=0; i<items.length; i++){  
    //XML item = xml.getChild(i);    
    // Capture the data from the XML.
    String iYear = items[i].getChild("date").getChild("year").getContent();
    //String iYear = item.getChild("date").getChild("year").getContent();
    itemYears.add(int(iYear)); // Populate the array itemYears.
  }
 
  textFont(regular);
  textAlign(CENTER);

  for (int yNumber=0; yNumber<((end-begin)+1); yNumber++){
    // List all years
    int aYear = allYears()[yNumber];
    // Get postions for each year
    int posY = listPosY()[yNumber];
    //If that year has an item, set fill to black and font size to 16pts.
    if (itemYears.contains(aYear)){
      fill(0);
      textSize(16);
    }else{// If not, set fill to grey and font size to 12pts.
      fill(200);
      textSize(12);
    }

    // Write the text of the year. Use ">=" to include the first year in the list
    if (yNumber>=0){
    text(str(aYear), 0, posY);
    }
    
    //  lines
    stroke(220);// Stroke colour: grey
    line(-timelineWidth/2,(posY+3), timelineWidth/2,(posY+3));
    line(timelineWidth/2, yNumber+3, timelineWidth/2, (posY+3));
    line(-timelineWidth/2, yNumber+3, -timelineWidth/2, (posY+3));
  }
  //draw the outline for the first year
    line(-timelineWidth/2,0-leading, timelineWidth/2,0-leading);
    line(timelineWidth/2, 0+3, timelineWidth/2, 0-leading);
    line(-timelineWidth/2, 0+3, -timelineWidth/2, 0-leading);
}



