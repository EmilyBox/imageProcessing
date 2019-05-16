import g4p_controls.*;
import java.awt.Font;
import java.util.Map;
import java.io.File;


GLabel title, imgTextLabel;
GTextField comparisonImgText;
GTextArea results;
GButton constrastBtn, redBtn, greenBtn, blueBtn, grayscaleBtn, bwBtn, jpgBtn, bmpBtn, pngBtn, gifBtn, compBtn;
boolean buttonClicked = false;
String imgName;
String dataPath, compareImg, picImg;

int[] rCounts = new int[256];  //bins for red histogram
int[] gCounts = new int[256];  //bins for green histogram
int[] bCounts = new int[256];  //bins for blue histogram

int[] r2Counts = new int[256];  //bins for 2nd red histogram
int[] g2Counts = new int[256];  //bins for 2nd green histogram
int[] b2Counts = new int[256];  //bins for 2nd blue histogram

PImage origImg;


HashMap<String, Float> imgValues = new HashMap<String, Float>();
HashMap<Integer, String> imgRanks = new HashMap<Integer, String>();

PImage img, resultImg;

                                        
String[] imgFiles = new String[0];
String colorChoice;

void setup() {
  size(600, 800);
  
  
  //Title
  title = new GLabel(this, 50, 75, 400, 30, "Image Comparisons"); 
  title.setFont(new Font("Monospaced", Font.BOLD, 28));
  
  
  //Buttons
  constrastBtn = new GButton(this, 130, 260, 100, 30, "Contrast"); 
  redBtn = new GButton(this, 130, 305, 100, 30, "Red");
  greenBtn = new GButton(this, 130, 350, 100, 30, "Green");
  blueBtn = new GButton(this, 130, 395, 100, 30, "Blue");
  grayscaleBtn = new GButton(this, 130, 440, 100, 30, "Grayscale");
  bwBtn = new GButton(this, 130, 485, 100, 30, "Black and White");
  jpgBtn = new GButton(this, 130, 530, 100, 30, "JPG");
  pngBtn = new GButton(this, 240, 530, 100, 30, "PNG");
  bmpBtn = new GButton(this, 20, 530, 100, 30, "BMP");
  gifBtn = new GButton(this, 130, 575, 100, 30, "GIF");
  compBtn = new GButton(this, 130, 620, 100, 30, "Compare");
  
  //Results
  results = new GTextArea(this, 375, 250, 200, 325, 1);
  
  //get Folder to use
  selectFolder("Select folder of images to search", "setDataFolder");
  
  
}

void draw() {
   background(255); 
   if(buttonClicked == true) image(resultImg, 375, 50, 200, 175);
}

//Function to set "Data" Folder
void setDataFolder(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    dataPath = selection.getAbsolutePath();
    setImgFiles();
  }
  
}

//Function to set imgFiles from chosen data folder
void setImgFiles() {
  File folder = new File(dataPath);
  File[] paths = folder.listFiles();
  for (int pth = 0; pth < paths.length; pth++) {
    String fpath = paths[pth].getName();
    imgFiles = append(imgFiles, fpath);
  }
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

//________________FUNCTIONS TO HANDLE EXTENSIONS AND GRAYSCALE/BLACK AND WHITE________________________________

String[] isPng(String[] options) {
  String[] files = new String[0]; 
  for(int i = 0; i < options.length; i++) {
    if (options[i].endsWith("png")) {
      files = append(files, options[i]);
    }
  }
  for ( int j = 0; j < files.length; j++) {
    results.appendText(files[j]);
  }
  return files;
}

String[] isJpg(String[] options) {
  String[] files = new String[0]; 
  for(int i = 0; i < options.length; i++) {
    if (options[i].endsWith("jpg")) {
      files = append(files, options[i]);
    }
  }
  for ( int j = 0; j < files.length; j++) {
    results.appendText(files[j]);
  }
  return files;
}

String[] isBmp(String[] options) {
  String[] files = new String[0]; 
  for(int i = 0; i < options.length; i++) {
    if (options[i].endsWith("bmp")) {
      files = append(files, options[i]);
    }
  }
  for ( int j = 0; j < files.length; j++) {
    results.appendText(files[j]);
  }
  return files;
}

String[] isGif(String[] options) {
  String[] files = new String[0]; 
  for(int i = 0; i < options.length; i++) {
    if (options[i].endsWith("gif")) {
      files = append(files, options[i]);
    }
  }
  for ( int j = 0; j < files.length; j++) {
    results.appendText(files[j]);
  }
  return files;
}


String[] isGrayScale(String[] options, PImage img) {
  Boolean isGray = true;
  String[] files = new String[0];   
 
  float r = 0, g = 0, b = 0;
  for (int i = 0; i < options.length; i++) {
    img = loadImage(options[i]);
    for (int y = 0; y < img.height; y++) {
      for (int x = 0; x < img.width; x++) {
        color c = img.get(x, y);
        r = red(c);
        g = green(c);
        b = blue(c);  
        if (r != g || r != b || g != b) {
          isGray = false;
        } 
      }
    }
      if (isGray) {
        files = append(files, options[i]);
      }
    isGray = true;
  }
    for ( int j = 0; j < files.length; j++) {
        results.appendText(files[j]);
    }
  return files;
}

String[] isBlackAndWhite(String[] options, PImage img) {
  Boolean isBandW = true;
  String[] files = new String[0];   
  
  float r = 0, g = 0, b = 0;
  for (int i = 0; i < options.length; i++) {
    img = loadImage(options[i]);
    for (int y = 0; y < img.height; y++) {
      for (int x = 0; x < img.width; x++) {
        color c = img.get(x, y);
        r = red(c);
        g = green(c);
        b = blue(c);
        if (r != 255.0 && r != 0.0 || g != 255.0 && g != 0.0 || b != 255.0 && b != 0.0) {     
          isBandW = false;
        } 
      }
    }
      if (isBandW) {
        files = append(files, options[i]);
      }
    isBandW = true;
  }
    for ( int j = 0; j < files.length; j++) {
        results.appendText(files[j]);
    }
  return files;
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
     results.setText("");
     buttonClicked = true;
     String[] grays = isGrayScale(imgFiles, img);
     imgName = grays[0];
     resultImg = loadImage(imgName);
   }
   else if(button == bwBtn && event == GEvent.CLICKED) {
          //insert black and white stuff 
     results.setText("");
     buttonClicked = true;
     String[] bws = isBlackAndWhite(imgFiles, img);
     imgName = bws[0];
     resultImg = loadImage(imgName);
   }
   else if(button == jpgBtn && event == GEvent.CLICKED) {
     //insert extension stuff 
     results.setText("");
     buttonClicked = true;
     String[] jpgs = isJpg(imgFiles);
     imgName = jpgs[0];
     resultImg = loadImage(imgName);
   }
   else if(button == bmpBtn && event == GEvent.CLICKED) {
     //insert extension stuff 
     results.setText("");
     buttonClicked = true;
     String[] bmps = isBmp(imgFiles);
     imgName = bmps[0];
     resultImg = loadImage(imgName);
   }
   else if(button == pngBtn && event == GEvent.CLICKED) {
     //insert extension stuff 
     results.setText("");
     buttonClicked = true;
     String[] pngs = isPng(imgFiles);
     imgName = pngs[0];
     resultImg = loadImage(imgName);
   }
   else if(button == gifBtn && event == GEvent.CLICKED) {
     //insert extension stuff 
     results.setText("");
     buttonClicked = true;
     String[] gifs = isGif(imgFiles);
     imgName = gifs[0];
     resultImg = loadImage(imgName);
   }
   else if(button == compBtn && event == GEvent.CLICKED) {
     //select whcih image to compare against and run functions against that
     //buttonClicked = true;
     results.setText("");
     selectInput("choose original image to comapre against", "setOrigImg");
     
     
     
   }
}
//Comparison functions
//=======================================================
void setOrigImg(File originalImg) {
  if (originalImg == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    compareImg = originalImg.getAbsolutePath();
  }
  String[] picts = compareImgs();
  imgName = picts[0];
  resultImg = loadImage(imgName);
  
  buttonClicked = true;
  
  
  
}
//gets filepaths from data folder, and ensures that only pictures are accepted
String[] compareImgs(){
  File folder = new File(dataPath);
  File[] pics = folder.listFiles();
  origImg = loadImage(compareImg);
  PImage[] imgs = new PImage[pics.length];
  for (int p = 0; p < pics.length; p++){
    String path = pics[p].getAbsolutePath();
    if (path.toLowerCase().endsWith(".jpg") || path.toLowerCase().endsWith(".png") 
     || path.toLowerCase().endsWith(".gif") || path.toLowerCase().endsWith(".bmp")
     || path.toLowerCase().endsWith(".jpeg")) {
      imgs[p] = loadImage(path);
    }
  }
  //create an array of the differences between the histograms
  int[] diffs = new int[imgs.length];
  for (int i = 0; i < imgs.length; i++) {
    calculateHists(origImg, imgs[i]);
    diffs[i] = compareHists();
    
  }
  
  
  int smallestDiff = 0;
  for (int d = 1; d < diffs.length; d++) {
    if (diffs[d] < diffs[smallestDiff]) {
      smallestDiff = d;
    }
    
  }
  
  //bubble sort on both arrays
  
  int bsN = diffs.length;
  for (int bsI = 0; bsI < bsN-1; bsI++) {
    for (int bsJ = 0; bsJ < bsN - bsI - 1; bsJ++) {
      if  (diffs[bsJ] > diffs[bsJ+1]) {
        int temp = diffs[bsJ];
        File temp2 = pics[bsJ];
        PImage temp3 = imgs[bsJ];
        diffs[bsJ] = diffs[bsJ+1];
        diffs[bsJ+1] = temp;
        pics[bsJ] = pics[bsJ+1];
        pics[bsJ+1] = temp2;
        imgs[bsJ] = imgs[bsJ+1];
        imgs[bsJ+1] = temp3;
      }
    }
  }
  
  String[] pics2 = new String[pics.length];
  for (int p2 = 0; p2 < pics.length; p2++) {
    pics2[p2] = pics[p2].getName();
  }
  results.setText(pics2);  
  return pics2;
}

//get the histograms from both images
void calculateHists(PImage img, PImage img2) {
  for (int i = 0; i < rCounts.length; i++) {
    rCounts[i] = 0; gCounts[i] = 0; bCounts[i] = 0;
  }
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      color c = img.get(x, y);
      int r = int(red(c)), g = int(green(c)), b = int(blue(c));
      rCounts[r] += 1;
      gCounts[g] += 1;
      bCounts[b] += 1;
    }
  }
  for (int i = 0; i < rCounts.length; i++) {
    r2Counts[i] = 0; g2Counts[i] = 0; b2Counts[i] = 0;
  }
  for (int y = 0; y < img2.height; y++) {
    for (int x = 0; x < img2.width; x++) {
      color c = img.get(x, y);
      int r = int(red(c)), g = int(green(c)), b = int(blue(c));
      r2Counts[r] += 1;
      g2Counts[g] += 1;
      b2Counts[b] += 1;
    }
  }
}

//get the difference in histograms of the original image and the current image
int compareHists() {
  int rDiff = 0, gDiff = 0, bDiff = 0;
  for (int i = 0; i < rCounts.length; i++) {
    rDiff += abs(rCounts[i]-r2Counts[i]);
    gDiff += abs(gCounts[i]-g2Counts[i]);
    bDiff += abs(bCounts[i]-b2Counts[i]);
  }
  int diffSum = rDiff + gDiff + bDiff;
  
  return diffSum;
  
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
  
  //print list of names (1 least amount of contrast)
  for(int i = 0; i< sorted.length; i++) {
      results.appendText((i + 1) + " - " + sorted[i]);
   }
   
   
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
