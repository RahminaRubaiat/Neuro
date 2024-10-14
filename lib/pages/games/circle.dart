// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:neuro_task/constant/my_text.dart';
// import 'package:neuro_task/pages/homepage.dart';
// import 'package:neuro_task/providers/memory_game_functions.dart';
// import 'package:neuro_task/services/trace_shape_services.dart';
// import 'package:neuro_task/ui/game/trace_shape_start_message.dart';
// import 'dart:typed_data';
// import 'package:screenshot/screenshot.dart';

// class Circle extends StatefulWidget {
//   const Circle({super.key});

//   @override
//   State<Circle> createState() => _CircleState();
// }

// class _CircleState extends State<Circle> {
//   int start = 0, end = 0;
//   final List<Offset> _points = [];
//   final List<List<Offset>> _pointsList = [];
//   final List<Offset> _points2 = [];
//   final List<List<Offset>> _pointsList2 = [];
//   bool isDrawingInsideBox = false;
//   bool isEndingInsideBox = false;
//   final CirclePainter _painter = CirclePainter();
//   bool _isDrawingInside = true;
//   String posX="",posY="",startTime="",endTime="",accuracy="";
//   Offset offsetOutside = Offset.zero;
  
//   final _screenshotController = ScreenshotController();
//   Uint8List? _capturedImageBytes;

//   void _captureScreenshot() async {
//     final imageBytes = await _screenshotController.capture();
//     setState(() {
//       _capturedImageBytes = imageBytes;
//     }); 
//     _showScreenShot();
//   }

//   _showScreenShot(){
//     return showDialog(
//       context: context, 
//       builder: (context) {
//         return AlertDialog(
//           title: Center(child: MyText(text: "ScreenShot", size: 60.sp, overflow: false, bold: true, color: Colors.black)),
//           content: Container(
//             height: 900.h,
//             width: 500.w,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(
//                 color: Colors.grey,
//                 width: 2.w,
//               )
//             ),
//             child: (_capturedImageBytes!=null)? Image.memory(
//               _capturedImageBytes!,
//               width: 200,
//               height: 200,
//             ) : const Center( child: CircularProgressIndicator()),
//           ),
//           actions: [
//             TextButton(
//               onPressed: (){
//                 Navigator.pop(context);
//                 Get.to(const HomePage());
//               }, 
//               child: const Text('OK')
//             ),
//           ],
//         );
//       },
//     );
//   }

  
//   void screenXYCoordinate(details){
//     final RenderBox box = context.findRenderObject() as RenderBox;
//           final Offset localOffset = box.globalToLocal(details.globalPosition);
//           final double x = localOffset.dx;
//           final double y = localOffset.dy;
//           // ignore: unused_local_variable
//           posX = x.toString();
//           // ignore: unused_local_variable
//           posY = y.toString();
//   }

//   final VelocityTracker velocityTracker = VelocityTracker.withKind(PointerDeviceKind.touch);
//   Offset offset = Offset.zero;
//   Offset lastPosition = Offset.zero;
//   void screenXYCoordinateEnd(Offset localPosition) {
//     final RenderBox box = context.findRenderObject() as RenderBox;
//     final Offset globalPosition = box.localToGlobal(localPosition);
//     final double x = globalPosition.dx;
//     final double y = globalPosition.dy;
//     setState(() {
//       posX = x.toString();
//       posY = y.toString();
//     });
//   }

//     @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       TraceShapeStartMessage.startMessage(context);
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Screenshot(
//           controller: _screenshotController,
//           child: Container(
//             height: double.maxFinite,
//             width: double.maxFinite,
//             color: Colors.white,
//             child: GestureDetector(
//               onPanStart: (details) {
//                 //Data Collection
//                 MemoryGameFunctions.findTime();
//                 TraceShapeService.lineStartTime.add(MemoryGameFunctions.formattedTime);
//                 screenXYCoordinate(details);
//                 TraceShapeService.startRegion.add("$posX,$posY");
//                 TraceShapeService.startLocation.add('0');
        
//                 setState(() {
//                   isDrawingInsideBox = screenBox(details.localPosition);
//                   isEndingInsideBox = true; // Reset the end status when drawing starts
//                   _points.add(details.localPosition); // Add the starting point
//                 });
//               },
//               onPanUpdate: (DragUpdateDetails details) {
//                 setState(() {
//                   offsetOutside = details.delta;
//                   _points.add(details.localPosition);
//                 });
//               },
//               onPanEnd: (DragEndDetails details) {
//                 if (_points.isNotEmpty) {
//                   _pointsList.add([..._points]);
//                   setState(() {
//                     isEndingInsideBox = screenBox(_points.last);
//                   });
//                   MemoryGameFunctions.findTime();
//                   TraceShapeService.lineEndTime.add(MemoryGameFunctions.formattedTime);
//                   // ignore: unused_local_variable
//                   //final velocity = velocityTracker.getVelocity();
//                   if (lastPosition != Offset.zero) {
//                     screenXYCoordinateEnd(lastPosition);
//                   }
//                   TraceShapeService.endRegion.add('$posX,$posY');
//                   (isEndingInsideBox) ? TraceShapeService.endLocation.add('1'):
//                   TraceShapeService.endLocation.add('0');
            
//                   // showDialog(
//                   //   context: context,
//                   //   builder: (_) => AlertDialog(
//                   //     title: const Text('Drawing Status'),
//                   //     content: Text(
//                   //       'Start: ${isDrawingInsideBox ? "Inside" : "Outside"}\n'
//                   //       'End: ${isEndingInsideBox ? "Inside" : "Outside"}',
//                   //     ),
//                   //     actions: [
//                   //       ElevatedButton(
//                   //         onPressed: () {
//                   //           Navigator.pop(context);
//                   //         },
//                   //         child: const Text('OK'),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // );
//                   _points.clear();
//                 }
//                 else{
//                   MemoryGameFunctions.findTime();
//                   TraceShapeService.lineEndTime.add(MemoryGameFunctions.formattedTime);
//                   if (lastPosition != Offset.zero) {
//                     screenXYCoordinateEnd(lastPosition);
//                   }
//                   TraceShapeService.endRegion.add('$posX,$posY');
//                   (isEndingInsideBox) ? TraceShapeService.endLocation.add('0'):
//                   TraceShapeService.endLocation.add('0');
//                 }
//                 TraceShapeService.accuracy.add('0.00');
//               },
//               child: Container(
//                 color: Colors.white,
//                 child: Stack(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TextButton(
//                           onPressed: (){
//                             Get.to(const HomePage());
//                           },
//                           child: const Text("Back",
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Color.fromARGB(166, 207, 207, 11),
//                             ),
//                           )
//                         ),
//                         TextButton(
//                           onPressed: (){
//                             TraceShapeService.reset();
//                             _points.clear();
//                             _points2.clear();
//                             _pointsList.clear();
//                             _pointsList2.clear();
//                           },
//                         child: const Text("Reset",
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Color.fromARGB(166, 207, 207, 11),
//                           ),
//                         )
//                        ),
//                         TextButton(
//                           onPressed: (){
//                             //TraceShapeService.traceShapeData();
//                             _captureScreenshot();
//                           },
//                         child: const Text("Submit",
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Color.fromARGB(166, 207, 207, 11),
//                           ),
//                         )
//                        ),
//                       ],
//                     ),
//                     Positioned(
//                       top: (MediaQuery.of(context).size.height - 1400.h) / 2,
//                       left: (MediaQuery.of(context).size.width - 900.w) / 2,
//                       width: 900.w,
//                       height: 1400.h,
//                       child: GestureDetector(
//                         onPanStart: (details) {
//                           //Data Collection
//                           _painter.addPoint(details.localPosition);
//                           _points2.add(details.localPosition);
//                           MemoryGameFunctions.findTime();
//                           TraceShapeService.lineStartTime.add(MemoryGameFunctions.formattedTime);
//                           screenXYCoordinate(details);
//                           TraceShapeService.startRegion.add("$posX,$posY");
//                           TraceShapeService.startLocation.add('1');
//                         },
//                         onPanUpdate: (details) {
//                           setState(() {
//                             _painter.addPoint(details.localPosition);
//                             _points2.add(details.localPosition);
//                             if (details.localPosition.dx < 0 ||
//                                 details.localPosition.dx > 900.h ||
//                                 details.localPosition.dy < 0 ||
//                                 details.localPosition.dy > 1400.w) {
//                               _isDrawingInside = false;
//                             }
//                           });
//                         },
//                         onPanEnd: (details) {
//                           _pointsList2.add([..._points2]);
//                           final accuracy = calculateAccuracy(_painter);
//                           //print(accuracy);
//                           // //print('end in box');
//                           // showDialog(
//                           //   context: context,
//                           //   builder: (_) => AlertDialog(
//                           //     title: const Text('Accuracy'),
//                           //     content: Text('${accuracy.toStringAsFixed(2)}%'),
//                           //     actions: [
//                           //       ElevatedButton(
//                           //         onPressed: () {
//                           //           Navigator.pop(context);
//                           //           setState(() {
//                           //             _painter.reset();
//                           //           });
//                           //         },
//                           //         child: const Text('OK'),
//                           //       ),
//                           //     ],
//                           //   ),
//                           // );
//                           setState(() {
//                             MemoryGameFunctions.findTime();
//                             TraceShapeService.lineEndTime.add(MemoryGameFunctions.formattedTime);
//                             if (lastPosition != Offset.zero) {
//                               screenXYCoordinateEnd(lastPosition);
//                             }
//                             TraceShapeService.endRegion.add('$posX,$posY');
//                             if (_isDrawingInside) {
//                               TraceShapeService.endLocation.add('1');
//                             } else {
//                               TraceShapeService.endLocation.add('0');
//                             }
//                             _isDrawingInside = true;
//                           });
//                           TraceShapeService.accuracy.add("${accuracy.toStringAsFixed(2)}%");
//                           _painter.reset();
//                           _points2.clear();
//                         },
//                         child: Container(
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             border: Border.all(
//                               color: Colors.grey,
//                               width: 5.w,
//                             )
//                           ),
//                           child: Stack(
//                             children: [
//                               Positioned(
//                                 child: CustomPaint(
//                                   size: Size(900.w, 1400.h),
//                                   painter: _painter,
//                                 ),
//                               ),
//                               Positioned(
//                                 child: CustomPaint(
//                                   painter: MyCustomPainter2(pointsList: _pointsList2),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ),
//                       ),
//                     ),
//                     CustomPaint(
//                       painter: MyCustomPainter(pointsList: _pointsList),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   bool screenBox(Offset point) {
//     final boxCenter = Offset(MediaQuery.of(context).size.width / 2,
//     MediaQuery.of(context).size.height / 2); // Center of the red box
//     final boxWidth = 900.w; // Width of the red box
//     final boxHeight = 1400.h; // Height of the red box

//     final leftBoundary = boxCenter.dx - boxWidth / 2;
//     final rightBoundary = boxCenter.dx + boxWidth / 2;
//     final topBoundary = boxCenter.dy - boxHeight / 2;
//     final bottomBoundary = boxCenter.dy + boxHeight / 2;

//     return point.dx >= leftBoundary &&
//         point.dx <= rightBoundary &&
//         point.dy >= topBoundary &&
//         point.dy <= bottomBoundary;
//   }

//   double calculateAccuracy(CirclePainter painter) {
//     final center = Offset(900.w / 2, 1400.h / 2); // Center of the screen
//     final radius = 900.sp / 3; // Radius of the circle
//     final numPoints = painter.points.length;

//     double totalDistance = 0;
//     for (final point in painter.points) {
//       final distance = (point - center).distance - radius;
//       totalDistance += distance.abs();
//     }

//     final averageDistance = totalDistance / numPoints;
//     final accuracy = (1 - averageDistance / radius) * 100;

//     return accuracy.clamp(0, 100);
//   }
// }

// class MyCustomPainter extends CustomPainter {
//   final List<List<Offset>> pointsList;

//   MyCustomPainter({required this.pointsList});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 4.0
//       ..strokeCap = StrokeCap.round;

//     for (final points in pointsList) {
//       for (int i = 0; i < points.length - 1; i++) {
//         canvas.drawLine(points[i], points[i + 1], paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

// class MyCustomPainter2 extends CustomPainter {
//   final List<List<Offset>> pointsList;

//   MyCustomPainter2({required this.pointsList});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 4.0
//       ..strokeCap = StrokeCap.round;

//     for (final points in pointsList) {
//       for (int i = 0; i < points.length - 1; i++) {
//         canvas.drawLine(points[i], points[i + 1], paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }


// class CirclePainter extends CustomPainter { 

//   final Paint _paint;
//   final List<Offset> points = [];

//   CirclePainter() : _paint = Paint()
//     ..color = Colors.yellow
//     ..strokeWidth = 5.0
//     ..style = PaintingStyle.stroke;

//   // final _paint2 = Paint()
//   //   ..color = Colors.black
//   //   ..strokeWidth = 3.0
//   //   ..style = PaintingStyle.stroke;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 3;
//     canvas.drawCircle(center, radius, _paint);

//     //  for (int i = 0; i < points.length-1; i++) {
//     //   canvas.drawLine(points[i], points[i + 1], _paint2);
//     // }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;

//   void addPoint(Offset point) {
//     points.add(point);
//   }

//   void reset() {
//     points.clear();
//   }
// }

