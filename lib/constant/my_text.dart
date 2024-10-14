import 'package:flutter/material.dart';
import 'package:neuro_task_android/constant/responsive.dart';

class MyText extends StatelessWidget {
  final String text;
  final double size;
  final bool bold;
  final Color color;
  final double height;
  final double width;
  const MyText({super.key, required this.text, required this.size,required this.bold, required this.color, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    double screenHeight = Responsive.screenHeight(context);
    double screenWidth = Responsive.screenWidth(context);
    return Container(
      height: screenHeight * height,
      width: screenWidth * width,
      color: Colors.transparent,
      child: FittedBox(
        child: Text(text,
        maxLines: 1,
          style: TextStyle(
            fontSize: (screenWidth / Responsive.designWidth) * size,
            fontWeight: (bold) ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ),
    );
  }
}