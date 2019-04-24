import g4p_controls.*;
import java.awt.Font;
import java.util.Map;

GLabel title, imgTextLabel;
GTextField comparisonImgText;
GTextArea results;
GButton constrastBtn, redBtn, greenBtn, blueBtn, grayscaleBtn, bwBtn, extensionBtn;
boolean buttonClicked = false;
String imgName;


HashMap<String, Integer> imgValues = new HashMap<String, Integer>();
HashMap<Integer, String> imgRanks = new HashMap<Integer, String>();

int redCount, greenCount, blueCount;
PImage img, resultImg;
String[] imgFiles ={"ColoredSquares.jpg", "red.jpg", "green.jpg", "blue.jpg", "4.2.03.jpg", "4.2.07.jpg", "eiffel.jpg", "temple.jpg", "waikiki.jpg", "gumballs.jpg", "colorful-1560.jpg", "hot_air.jpg", "Lizard.jpg"};
String colorChoice;

void setup() {
  size(600, 600);
  
  //Title
  title = new GLabel(this, 50, 75, 400, 30, "Image Comparisons"); 
  title.setFont(new Font("Monospaced", Font.BOLD, 28));
  
  //Img comparison
  imgTextLabel = new GLabel(this, 75, 145, 400, 30, "Name of image to compare:");
  imgTextLabel.setFont(new Font("Monospaced", Font.BOLD, 15));
  comparisonImgText = new GTextField(this, 100, 175, 175, 30);
  
  //Buttons
  constrastBtn = new GButton(this, 130, 260, 100, 30, "Contrast"); 
  redBtn = new GButton(this, 130, 305, 100, 30, "Red");
  greenBtn = new GButton(this, 130, 350, 100, 30, "Green");
  blueBtn = new GButton(this, 130, 395, 100, 30, "Blue");
  grayscaleBtn = new GButton(this, 130, 440, 100, 30, "Grayscale");
  bwBtn = new GButton(this, 130, 485, 100, 30, "Black and White");
  extensionBtn = new GButton(this, 130, 530, 100, 30, "Extensions");
  
  //Results
  results = new GTextArea(this, 375, 250, 200, 325, 1);
  
}

void draw() {
   background(0); 
   if(buttonClicked == true) image(resultImg, 375, 50, 200, 175);
}

int calcHists(PImage img, String colorChoice) {

  /*For each pixel, get the red, green, and blue values as ints.
    Increment the counts for the red, green, and blue values.
  */
  for(int y = 0; y < img.height; y++) {
    for(int x = 0; x < img.width; x++) {
      color c = img.get(x, y);
      int r = int(red(c));
      int g = int(green(c));
      int b = int(blue(c));

      redCount += r;
      greenCount += g;
      blueCount += b;
    }
  }
  /*print("\nRED: ", redCount);
  print("\nGREEN: ", greenCount);
  print("\nBLUE: ", blueCount);*/
  
  if(colorChoice == "red") return redCount;
  else if(colorChoice == "green") return greenCount;
  else return blueCount;
}

void printHists() {
  print('\n');
  for(Map.Entry me : imgValues.entrySet()) {
      print(me.getKey() + " is ");
      println(me.getValue());
   }
   print('\n');
}

void getPixelValue() {
  for(int i = 0; i < imgFiles.length; i++) {
     img = loadImage(imgFiles[i]);
     int pixelValue = calcHists(img, colorChoice);
     imgValues.put(imgFiles[i], pixelValue);
   }
}

String sortImages() {
  int[] pixelValues = {};
  int[] sortedValues = {};
  for(Map.Entry me : imgValues.entrySet()) {
    int value = (Integer) me.getValue();
    pixelValues = append(pixelValues, value);
  }
  
  sortedValues = sort(pixelValues);

  for(Map.Entry me : imgValues.entrySet()) {
    for(int i = 0; i < sortedValues.length; i++) {
      if(me.getValue().equals(sortedValues[i])) {
        imgRanks.put(i, (String) me.getKey());
      }
    }
  }
  String highestImg = imgRanks.get(sortedValues.length-1);
  
  for(Map.Entry me : imgRanks.entrySet()) {
      //print(me.getKey() + " is ");
      //println(me.getValue());
      results.appendText(((int)me.getKey() + 1) + " - " + (String)me.getValue());
   }
   
   return highestImg;
}

public void handleButtonEvents(GButton button, GEvent event) {
   if(button == constrastBtn && event == GEvent.CLICKED) {
      //insert constrast stuff 
   }
   else if(button == redBtn && event == GEvent.CLICKED) {
     results.setText("");
     buttonClicked = true;
     colorChoice = "red";
     getPixelValue();
     //printHists();
     imgName = sortImages();
     resultImg = loadImage(imgName);
   }
   else if(button == greenBtn && event == GEvent.CLICKED) {
     results.setText("");
     buttonClicked = true;
     colorChoice = "green";
     getPixelValue();
     //printHists();
     imgName = sortImages();
     resultImg = loadImage(imgName);
   }
   else if(button == blueBtn && event == GEvent.CLICKED) {
     results.setText("");
     buttonClicked = true;
     colorChoice = "blue";
     getPixelValue();
     //printHists();
     imgName = sortImages();
     resultImg = loadImage(imgName);
   }
   else if(button == grayscaleBtn && event == GEvent.CLICKED) {
     //insert grayscale stuff 
   }
   else if(button == bwBtn && event == GEvent.CLICKED) {
     //insert black and white stuff 
   }
   else if(button == extensionBtn && event == GEvent.CLICKED) {
     //insert extension stuff 
   }
}
