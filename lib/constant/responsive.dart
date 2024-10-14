import 'package:flutter/material.dart';

class Responsive {

  static double designHeight = 375;
  static double designWidth = 667;
  
  static double screenHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }
  static double screenWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
}