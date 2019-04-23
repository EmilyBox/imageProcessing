//Determins the photo with the greatest contrast
//Various methods on how to measure contrast
    //https://en.wikipedia.org/wiki/Contrast_(vision)
PImage result;
void setup(){
  PImage testSearchImg = loadImage("face.jpg");
  PImage img1 = loadImage("waterfall_overexposed.jpg");
  PImage img2 = loadImage("man_overexposed.jpg");
  PImage img3 = loadImage("low_contrast_woman.jpg");
  PImage [] images = {img1, img2, img3};
  
  size(400, 400);
  surface.setResizable(true);
  result = highestContrast(testSearchImg, images);
  surface.setSize(result.width, result.height);
  
  
  
}

void draw() {
  image(result, 0, 0);
}

PImage highestContrast(PImage testImage, PImage imglist []){
  PImage highestContrast = new PImage();
  float contrastdiff = 1000;
  for(int i =0; i< imglist.length ; i++){
    float contrastdiff2 = abs(getContrast(testImage) - getContrast(imglist[i]));
    
    if(contrastdiff2 < contrastdiff){
      contrastdiff = contrastdiff2;
      highestContrast = imglist[i];
    }
  }
  return highestContrast;
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
