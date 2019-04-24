//Determins the photo with the greatest contrast
//Various methods on how to measure contrast
    //https://en.wikipedia.org/wiki/Contrast_(vision)
PImage result;
void setup(){
  String [] fileNames = {"waterfall_overexposed.jpg","face.jpg","man_overexposed.jpg","low_contrast_woman.jpg"};
  PImage [] images = {loadImage(fileNames[0]), loadImage(fileNames[1]), loadImage(fileNames[2]),loadImage(fileNames[3])};
  
  String[] sortedContrast = highestContrast(fileNames, images);
  
  print("Least to most Contrasted Images = ");
  for(int i =0; i< sortedContrast.length ; i++){
    print(sortedContrast[i],"  ");
  }
  
  
  
}



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
