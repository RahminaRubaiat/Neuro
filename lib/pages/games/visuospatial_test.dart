import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuro_task_android/constant/responsive.dart';
import 'package:neuro_task_android/pages/homepage.dart';
import 'package:neuro_task_android/services/visuospatial_test_services.dart';
import 'package:neuro_task_android/ui/message/start_message.dart';
import 'package:screenshot/screenshot.dart';

class VisuospatialTest extends StatefulWidget {
  const VisuospatialTest({super.key});

  @override
  State<VisuospatialTest> createState() => _VisuospatialTestState();
}

class _VisuospatialTestState extends State<VisuospatialTest> {

   startMessage(){
    return showGeneralDialog(
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      context: context, 
      pageBuilder: (context, animation, secondaryAnimation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.55,
              color: Colors.white,
              child: Card(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text("Visuospatial Test",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (width/Responsive.designWidth) * 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.02),
                      child: Text("Instruction",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: (width/Responsive.designWidth) * 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02,vertical: height * 0.02),
                      child: Text("Draw a line connecting the shapes in increasing numerical order from 1-10. Tap continue to begin and submit when you are done.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: (width/Responsive.designWidth) * 30,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: Text("Continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (width/Responsive.designWidth) * 40,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(166, 207, 207, 11),
                      ),
                    ),
                    ),
                  ],
                ),
              )
            ),
          ],
        );
      },
    );
  }

  String url = 'assets/images/';
  Map<int,Map<String, Offset>> circlePositions = {
    1 : {
      'shape1' : const Offset(0.5, 0.2),
      'shape2' : const Offset(0.2, 0.35),
      'shape3' : const Offset(0.45, 0.35),
      'shape4' : const Offset(0.3, 0.5),
      'shape5' : const Offset(0.55, 0.45),
      'shape6' : const Offset(0.7, 0.3),
      'shape7' : const Offset(0.8, 0.4),
      'shape8' : const Offset(0.5, 0.6),
      'shape9' : const Offset(0.8, 0.55),
      'shape10' : const Offset(0.4, 0.75),
    },
    2 : {
      'shape1' : const Offset(0.1, 0.2),
      'shape2' : const Offset(0.2, 0.3),
      'shape3' : const Offset(0.3, 0.15),
      'shape4' : const Offset(0.35, 0.5),
      'shape5' : const Offset(0.6, 0.2),
      'shape6' : const Offset(0.65, 0.35),
      'shape7' : const Offset(0.9, 0.2),
      'shape8' : const Offset(0.9, 0.6),
      'shape9' : const Offset(0.8, 0.35),
      'shape10' : const Offset(0.3, 0.8),
    },
    3 : {
      'shape1' : const Offset(0.8, 0.7),
      'shape2' : const Offset(0.6, 0.5),
      'shape3' : const Offset(0.8, 0.3),
      'shape4' : const Offset(0.4, 0.35),
      'shape5' : const Offset(0.7, 0.2),
      'shape6' : const Offset(0.1, 0.3),
      'shape7' : const Offset(0.4, 0.6),
      'shape8' : const Offset(0.1, 0.6),
      'shape9' : const Offset(0.25, 0.7),
      'shape10' : const Offset(0.8, 0.8),
    },
  };

  Random random = Random();
  int circlePositionKey = 1;
  String? lastEnteredCircle;
  List<Offset> points = [];
  bool isFirstTouch = true;
  Map<int,Map<String,dynamic>> gameInformation = {};
  int indexKey = 1;
  VisuospatialTestServices visuospatialTestServices = VisuospatialTestServices();
  
  void getRandomPosition(){
    circlePositionKey = random.nextInt(3) + 1;

  }

  final _screenshotController = ScreenshotController();
  Uint8List? _capturedImageBytes;

  void _captureScreenshot() async {
    final imageBytes = await _screenshotController.capture();
    setState(() {
      _capturedImageBytes = imageBytes;
    }); 
    visuospatialTestServices.visuospatialTestDataToFirebase(gameInformation).whenComplete((){
      visuospatialTestServices.visuospatialTestScreenshotToFirebaseStorage(_capturedImageBytes!);
    });
  }


  @override
  void initState() {
    getRandomPosition();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startMessage();
    });
    super.initState();
  }

  double height = 0.0,width = 0.0;
  
  @override
  Widget build(BuildContext context) {
     height = Responsive.screenHeight(context);
    width = Responsive.screenWidth(context);
    final circleDiameter = width * 0.1;
    final circleRadius = circleDiameter / 2;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Screenshot(
        controller: _screenshotController,
        child: Stack(
          children: [
            for (MapEntry<String, Offset> entry in circlePositions[circlePositionKey]!.entries)
            Positioned(
              left: entry.value.dx * width - circleRadius,
              top: entry.value.dy * height - circleRadius,
              child: Container(
                width: circleDiameter,
                height: circleDiameter,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage('$url${entry.key}.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  points.add(details.localPosition);
                });
                bool isOnCircle = false;
                for (MapEntry<String, Offset> entry in circlePositions[circlePositionKey]!.entries) {
                  if (isPointOnCircle(Offset(entry.value.dx * width, entry.value.dy * height),details.localPosition,circleRadius)) {
                    if (lastEnteredCircle != entry.key) {
                      final intersection = findIntersection(entry.value.dx * width,entry.value.dy * height, details.localPosition.dx, details.localPosition.dy);
                      // print("Container ${entry.key} Center: (${entry.value.dx * width}, ${entry.value.dy * height})");
                      // print("Intersection Point: (${intersection.dx}, ${intersection.dy})");
                      DateTime now = DateTime.now();
                      gameInformation[indexKey] = {
                        'Device Time' : '${now.hour}:${now.minute}:${now.second}',
                        'Shape Number' : entry.key,
                        'Shape Position Center (X,Y)' : '${entry.value.dx * width} , ${entry.value.dy * height}',
                        'Line Position (X,Y)' : '${intersection.dx} , ${intersection.dy}',
                      };
                      indexKey++;
                      lastEnteredCircle = entry.key;
                      isFirstTouch = false;
                    }
                    isOnCircle = true;
                    break;
                  }
                }
                if (!isOnCircle) {
                  if(isFirstTouch){
                    DateTime now = DateTime.now();
                    gameInformation[indexKey] = {
                      'Device Time' : '${now.hour}:${now.minute}:${now.second}',
                      'Shape Number' : -1,
                      'Shape Position Center (X,Y)' : 'null',
                      'Line Position (X,Y)' : 'null',
                    };
                    indexKey++;
                    isFirstTouch = false;
                  }
                  lastEnteredCircle = null;
                }
              },
              child: CustomPaint(
                painter: LinePainter(points: points),
                size: Size.infinite,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: height * 0.9,
              child: Container(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 0.0,
                      color: Colors.white,
                      child: TextButton(
                      onPressed: (){
                        Get.to(const HomePage());
                      },
                      child: Text("Back",
                        style: TextStyle(
                          fontSize: (width / Responsive.designWidth) * 30,
                          color: const Color.fromARGB(166, 207, 207, 11),
                        ),
                      )
                    ),
                    ),
                    const StartMessage(
                      gameName: 'Visuospatial Test',
                      description: "Draw a line connecting the shpaes in increasing numerical order from 1-10. Tap continue to begin and submit when you are done."
                    ),
                    Card(
                      elevation: 0.0,
                      color: Colors.white,
                      child: TextButton(
                        onPressed: (){
                          _captureScreenshot();
                          // gameInformation.forEach((key, value) {
                          //   value.forEach((k, v) {
                          //     print('$k : $v');
                          //   });
                          // });
                          Get.to(const HomePage());
                        },
                        child: Text("Submit",
                        style: TextStyle(
                          fontSize: (width/Responsive.designWidth) * 30,
                          color: const Color.fromARGB(166, 207, 207, 11),
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: height * 0.9,
              left: width * 0.2,
              right: width * 0.2,
              bottom: height * 0.02,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      spreadRadius: 2,
                      blurRadius: 2,
                    )
                  ]
                ),
                child: FittedBox(
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.01),
                    child: IconButton(
                      onPressed: (){
                        gameInformation.clear();
                        indexKey = 1;
                        points.clear();
                        circlePositionKey = random.nextInt(3) + 1;
                        isFirstTouch = true;
                        setState(() {
                          
                        });
                      }, 
                      icon: Icon(Icons.refresh,color: Colors.black,size: (width/Responsive.designWidth)*100,),
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
  bool isPointOnCircle(Offset circlePosition, Offset point, double circleRadius) {
    double distance = (circlePosition - point).distance;
    return distance <= circleRadius;
  }

  Offset findIntersection(double x1, double y1, double x2, double y2) {
    final slope = (y2 - y1) / (x2 - x1);
    final x = x1 + (x2 - x1) * 0.5;
    final y = y1 + slope * (x - x1);
    return Offset(x, y);
  }
}

class LinePainter extends CustomPainter {
  List<Offset> points;

  LinePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isNotEmpty) {
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(points[i], points[i + 1], Paint()..color = Colors.black..strokeWidth=3);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}