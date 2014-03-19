// 7.
// Type the identification of the timelime 
String title = "Title"; //add a title between the "".
String subtitle = "Subtitle";//add a subtitle between the "".
String author = "Author";//add your name between the "".
String affiliation1 = "Affiliation";//add an institution between the "".
String wYear = "Date";//add a date between the "".

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
  text(affiliation1, width/2, height-(labelsLeading*3)); //(Content, horizontal position, vertical position)
  //year
  textFont(regular, 12); //Font size: 10pts
  textAlign(CENTER);
  text(wYear, width/2, height-(labelsLeading*2)); //(Content, horizontal position, vertical position)
  
}

