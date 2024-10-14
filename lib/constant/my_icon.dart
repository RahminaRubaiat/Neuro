import 'package:flutter/material.dart';

class MyIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  const MyIcon({super.key, required this.icon, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color,
    );
  }
}