// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<Offset> points = []; // List to store points of the line drawn by the user
//   Map<String, Offset> circlePositions = {}; // Map to store positions of the circles
//   String? lastEnteredCircle; // Variable to store the last entered circle

//   @override
//   void initState() {
//     super.initState();
//     // Initialize positions of circles
//     circlePositions['1'] = Offset(0.2, 0.2);
//     circlePositions['2'] = Offset(0.5, 0.5);
//     circlePositions['3'] = Offset(0.8, 0.8);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final circleDiameter = screenWidth * 0.1;
//     final circleRadius = circleDiameter / 2;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Responsive Circle Detection'),
//       ),
//       body: Stack(
//         children: [
//           GestureDetector(
//             onPanUpdate: (details) {
//               setState(() {
//                 points.add(details.localPosition);
//               });
//               bool isOnCircle = false;
//               // Check if line intersects with any of the circles
//               for (MapEntry<String, Offset> entry in circlePositions.entries) {
//                 if (isPointOnCircle(
//                     Offset(entry.value.dx * screenWidth, entry.value.dy * screenHeight),
//                     details.localPosition,
//                     circleRadius)) {
//                   if (lastEnteredCircle != entry.key) {
//                     final intersection = findIntersection(entry.value.dx * screenWidth,
//                         entry.value.dy * screenHeight, details.localPosition.dx, details.localPosition.dy);
//                     print("Container ${entry.key} Center: (${entry.value.dx * screenWidth}, ${entry.value.dy * screenHeight})");
//                     print("Intersection Point: (${intersection.dx}, ${intersection.dy})");
//                     lastEnteredCircle = entry.key; // Update last entered circle
//                   }
//                   isOnCircle = true;
//                   break;
//                 }
//               }
//               // If the line goes outside all circles, reset lastEnteredCircle
//               if (!isOnCircle) {
//                 lastEnteredCircle = null;
//               }
//             },
//             child: CustomPaint(
//               painter: LinePainter(points: points),
//               size: Size.infinite,
//             ),
//           ),
//           // Display circles on top of the line
//           for (MapEntry<String, Offset> entry in circlePositions.entries)
//             Positioned(
//               left: entry.value.dx * screenWidth - circleRadius,
//               top: entry.value.dy * screenHeight - circleRadius,
//               child: Container(
//                 width: circleDiameter,
//                 height: circleDiameter,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.blue,
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   entry.key,
//                   style: TextStyle(fontSize: circleDiameter * 0.4, color: Colors.white),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   bool isPointOnCircle(Offset circlePosition, Offset point, double circleRadius) {
//     double distance = (circlePosition - point).distance;
//     return distance <= circleRadius; // Check if distance from center is less than circle radius
//   }

//   Offset findIntersection(double x1, double y1, double x2, double y2) {
//     final slope = (y2 - y1) / (x2 - x1);
//     final x = x1 + (x2 - x1) * 0.5; // Assuming line intersects at the midpoint
//     final y = y1 + slope * (x - x1);
//     return Offset(x, y);
//   }
// }

// class LinePainter extends CustomPainter {
//   List<Offset> points;

//   LinePainter({required this.points});

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Draw lines
//     if (points.isNotEmpty) {
//       for (int i = 0; i < points.length - 1; i++) {
//         if (points[i] != null && points[i + 1] != null) {
//           canvas.drawLine(points[i], points[i + 1], Paint()..color = Colors.red);
//         }
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
