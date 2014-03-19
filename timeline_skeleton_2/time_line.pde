
// Generate a list of years
int[] allYears;
int[] allYears(){  
  allYears = new int[(timespan)+1]; // +1 to include the fisrt year.
  for (int i=0; i<=(allYears.length-1); i++){ //-1 cause it counts from 0
    allYears[i]= i + (begin);
  }
  return allYears;
}

// Generate a list of positions in Y for each year.
int[] listPosY;
int[] listPosY(){
  listPosY = new int[(timespan)+1];
  numItemsPerYear = 0; //Reset the number of items a year factor for each call of this function.
  for ( int i=0; i<=(listPosY.length-1); i++){ 
    numItems = numItemsPerYear(allYears[i]); //Call the factor of displacement.
    listPosY[i] = (i*leading)+(leading*numItems);//numItemsPerYear(allYears[i]));
  }
  return listPosY;
}

//Generate a HashMap (dictionary). The key = year, the value is the x position on the timeline.
HashMap yearPositions;
HashMap yearPositions(){
  HashMap yearPositions = new HashMap((timespan)+1); 
  for (int i=0; i<(timespan)+1; i++){
    yearPositions.put(allYears[i], listPosY[i]);
  } 
  return yearPositions;
}

// Check how many items there are for each year.
// initial values for number of items per year and for one specific year 
int numItemsPerYear = 0;
int numItems = 0;

int numItemsPerYear(int pYear){
  XML[] items = xml.getChildren("item");
  String tYear = str(pYear);
  int numItems = 0;
  for (int j=0;j<items.length;j++){
    //Check whether the item's year is the same as the year being evaluated
     if (items[j].getChild("date").getChild("year").getContent().contains(tYear)){
        //if true add one to the numbers of items that year
        numItems += 1;
    }
  }    
    // if there are more than one items then adjust the timeline accordingly.
    if (numItems > 1){
          numItemsPerYear += (numItems - 1);
     } 
  return numItemsPerYear;
}


void timeLine(int begin, int end, ArrayList yearsWithItem){
  
  textFont(regular);
  textAlign(CENTER);

  for (int yNumber=0; yNumber<((end-begin)+1); yNumber++){
    // List all years
    int aYear = allYears()[yNumber];
    // Get postions for each year
    int posY = listPosY()[yNumber];
    //If that year has an item, set fill to black and font size to 16pts.
    if (yearsWithItem.contains(aYear)){
      fill(0);
      textSize(16);
    }else{// If not, set fill to grey and font size to 12pts.
      fill(200);
      textSize(12);
    }

    // Write the text of the year.
    text(str(aYear), 0, posY);
    
    //  Draw boxes around the text, use lines
    stroke(220);// Stroke colour: grey
    line(-timelineWidth/2,(posY+3), timelineWidth/2,(posY+3));
    line(timelineWidth/2, yNumber+3, timelineWidth/2, (posY+3));
    line(-timelineWidth/2, yNumber+3, -timelineWidth/2, (posY+3));
  }
  // Draw the outline for the first year
    line(-timelineWidth/2,0-leading, timelineWidth/2,0-leading);
    line(timelineWidth/2, 0+3, timelineWidth/2, 0-leading);
    line(-timelineWidth/2, 0+3, -timelineWidth/2, 0-leading);
    
}



