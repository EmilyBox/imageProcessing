import java.util.Map;



HashMap<String, Integer> imgValues = new HashMap<String, Integer>();
HashMap<Integer, String> imgRanks = new HashMap<Integer, String>();

int redCount, greenCount, blueCount;

PImage img;
String[] imgFiles ={"ColoredSquares.jpg", "colorful-1560.jpg", "hot_air.jpg", "Lizard.jpg"};
String colorOption = "Please choose a color. Press 'r' for red, 'g' for green or 'b' for blue";
String colorChoice;

void setup() {
   size(200, 200); //set an initial size
   surface.setResizable(true);
   img = loadImage("colorful-1560.jpg");
   surface.setSize(img.width, img.height);
}

void draw() {
  background(0);
  text(colorOption, 50, 50);
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
  if(colorChoice == "red") return redCount;
  else if(colorChoice == "green") return greenCount;
  else return blueCount;
}

void printHists() {
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


void keyPressed() {
   if(key == 'r') {
     colorChoice = "red";
     getPixelValue();
     printHists();
     sortImages();
   }
   else if(key == 'g') {
     colorChoice = "green";
     getPixelValue();
     sortImages();
   }
   else if(key == 'b') {
     colorChoice = "blue";
     getPixelValue();
     sortImages();
   }
   else {
    colorOption = "Not a color choice, please choose for the following option: red, green, or blue"; 
   }
}

void sortImages() {
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
  
  for(Map.Entry me : imgRanks.entrySet()) {
      print(me.getKey() + " is ");
      println(me.getValue());
   }
   print('\n');
}
