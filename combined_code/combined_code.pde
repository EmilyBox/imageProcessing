import g4p_controls.*;
import java.awt.Font;
import java.util.Map;


GLabel title, imgTextLabel;
GTextField comparisonImgText;
GTextArea results;
GButton constrastBtn, redBtn, greenBtn, blueBtn, grayscaleBtn, bwBtn, extensionBtn;
boolean buttonClicked = false;
String imgName;


HashMap<String, Float> imgValues = new HashMap<String, Float>();
HashMap<Integer, String> imgRanks = new HashMap<Integer, String>();

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
   background(255); 
   if(buttonClicked == true) image(resultImg, 375, 50, 200, 175);
}

//__________FUNCTIONS FOR SORTING BY PIXEL COLOR____________________________
float calcHists(PImage img, String colorChoice, float pixelNum) {
  int redCount = 0, greenCount = 0, blueCount = 0;
  /*For each pixel, get the red, green, and blue values as ints.
    Increment the counts for the red, green, and blue values.
  */
  for(int y = 0; y < img.height; y++) {
    for(int x = 0; x < img.width; x++) {
      color c = img.get(x, y);
      float r = red(c);
      float g = green(c);
      float b = blue(c);

      redCount += r;
      greenCount += g;
      blueCount += b;
    }
  }
  float redP = redCount / pixelNum;
  float greenP = greenCount / pixelNum;
  float blueP = blueCount / pixelNum;
  
  if(colorChoice == "red") return redP;
  else if(colorChoice == "green") return greenP;
  else return blueP;
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
     float numPixels = img.width * img.height;
     float pixelValue = calcHists(img, colorChoice, numPixels);
     imgValues.put(imgFiles[i], pixelValue);
   }
}

String sortImages() {
  float[] pixelValues = {};
  float[] sortedValues = {};
  for(Map.Entry me : imgValues.entrySet()) {
    float value = (Float) me.getValue();
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
//_____________________________________________________________________________________

//________________FUNCTION TO HANDLE BUTTON CLICKS________________________________
public void handleButtonEvents(GButton button, GEvent event) {
   if(button == constrastBtn && event == GEvent.CLICKED) {
      //insert constrast stuff 
      results.setText("");
      buttonClicked = true;
      PImage [] contrastfiles = new PImage[imgFiles.length];
      for(int i =0; i<imgFiles.length; i++){
        contrastfiles[i] = loadImage(imgFiles[i]);     
      }
      
      String[] contrastList = highestContrast(imgFiles, contrastfiles);
      
      imgName = contrastList[imgFiles.length - 1];
      resultImg = loadImage(imgName);
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

//Contrast functtions
//====================================
String[] highestContrast(String files[], PImage imglist []){
  String sorted[] = files;
  float contrastValues[] = new float[files.length];
  for(int i =0; i< imglist.length ; i++){
    float contrastValue = getContrast(imglist[i]);
    contrastValues[i] = contrastValue;
    }
    
  float sortedValues [] = contrastValues; 
  
  /*
  //testing unsorted list
  print("UnSorted: ");
  for(int i =0; i< imglist.length ; i++){
    print(files[i], "-",contrastValues[i],"  ");
  }
  print("\n");
  */
  
  //sort
  for(int i =0; i< imglist.length ; i++){
    for (int j = i+1; j < imglist.length; j++) {
                if ( (sortedValues[i] > sortedValues[j]) && (i != j) ) {
                    float temp = sortedValues[j];
                    String tempName = sorted[j];
                    sortedValues[j] = sortedValues[i];
                    sorted[j] = sorted[i];
                    sortedValues[i] = temp;
                    sorted[i] = tempName;
      }
    }
  }
  /*
  //testing sorted
  print("Sorted: ");
  for(int i =0; i< imglist.length ; i++){
    print(sorted[i], "-",sortedValues[i],"  ");
  }
  */
   
  return sorted;
}

//Michelson Contrast Method 
float getContrast(PImage img) {
  float maxLum = 0;
  float minLum = 10000;
  for (int i=0; i<img.pixels.length; i++) {
    float r = img.pixels[i] >> 16 & 0xFF;
    float g = img.pixels[i] >> 8 & 0xFF;
    float b = img.pixels[i] & 0xFF;
    float brightness = (0.2126 * r) + (0.7152 * g) + (0.0722 * b);
    if (brightness > maxLum) maxLum = brightness;
    if (brightness < minLum) minLum = brightness;
  }
  return (maxLum - minLum)/(maxLum + minLum);
}
