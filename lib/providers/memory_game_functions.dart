import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemoryGameFunctions{

  static DateTime?currentTime;
  static String formattedTime = "";

  static void findTime(){
    currentTime = DateTime.now();
    formattedTime = DateFormat('HH:mm:ss').format(currentTime!);
  }
  
  //Screen Position
  static int screenPosition = 0;
  static void screenPositionValue(TapDownDetails details, BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    double tapPosition = details.localPosition.dy;

    if (tapPosition < screenHeight / 3) {
      screenPosition = 1;
    } 
    else if (tapPosition < 2 * screenHeight / 3) {
      screenPosition = 2;
    } 
    else {
      screenPosition = 3;
    }
  }

  static int cardPosition = 0;
  static void cardPositionValue(TapUpDetails details,BuildContext context) {
    final cardHeight = MediaQuery.of(context).size.height * 0.2;
    final cardWidth = MediaQuery.of(context).size.width * 0.3;
    final offsetX = details.localPosition.dx - cardWidth / 2;
    final offsetY = details.localPosition.dy - cardHeight / 2;

    if (offsetY < -cardHeight / 4) {
      cardPosition = 0;
    } else if (offsetY > cardHeight / 4) {
      cardPosition = 6;
    } else {
      cardPosition = 3;
    }

    if (offsetX < -cardWidth / 4) {
      cardPosition+=1;
    } else if (offsetX > cardWidth / 4) {
      cardPosition+=3;
    } else {
      cardPosition+=2;
    }
  }

  

}