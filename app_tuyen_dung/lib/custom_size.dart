const double designedHeight = 866.2857142857143;
class CustomSize {
  static double textFieldSz = 20;

  static void setSize(double deviceHeight){
    textFieldSz = textFieldSz * deviceHeight/designedHeight;
    print(textFieldSz);
  }
}