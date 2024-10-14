import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuro_task_android/constant/responsive.dart';
import 'package:neuro_task_android/pages/homepage.dart';
import 'package:neuro_task_android/services/target_game_services.dart';
import 'package:neuro_task_android/ui/message/start_message.dart';
class TargetGame extends StatefulWidget {
  const TargetGame({super.key});

  @override
  State<TargetGame> createState() => _TargetGameState();
}

class _TargetGameState extends State<TargetGame> {

  double positionX = 0.0;
  double positionY = 0.0;
  Random random = Random();
  int index = 0;
  Map<double,double> circleSize = {
    0.1 : 0.05,
    0.09 : 0.045,
    0.095 : 0.0475,
    0.08 : 0.04,
  };
  void getRandomPosition(){
    index = random.nextInt(4);
    //debugPrint('index: $index');
    positionX = (0 + random.nextDouble() * (0.8 - 0));
    positionY = (0.1 + random.nextDouble() * (0.8 - 0.1));
  }

  Timer? timer;
  int second = 30;
  void startTimer(){
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        second--;
      });
    });
  }

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
                    Text("Target Game",
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
                      child: Text("Tap as many targets as you can in the given 30 seconds. Tap continue to begin and submit when you are done.",
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
                        startTimer();
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
                    // SizedBox(height: height * 0.01),
                    // InkWell(
                    //   onTap:(){
                        
                    //   },
                    //   child: Icon(Icons.keyboard_arrow_up,
                    //     size: (width/Responsive.designWidth) * 50,
                    //   ),
                    // ),
                  ],
                ),
              )
            ),
          ],
        );
      },
    );
  }

  double height = 0.0;
  double width = 0.0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startMessage();
    });
    getRandomPosition();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    height = Responsive.screenHeight(context);
    width = Responsive.screenWidth(context);
    return Scaffold(
      body: GestureDetector(
        onTapUp: (TapUpDetails details) {
          Offset tapPosition = details.globalPosition;
          debugPrint('Container Position: (${(positionX*width)+(height * circleSize.values.elementAt(index))} ${(positionY*height)+(height * circleSize.values.elementAt(index))})');
          debugPrint("Tap Position Outside: (${tapPosition.dx}, ${(tapPosition.dy)-(height * 0.1)})");
          TargetGameServices.targetGameDataFirebase(
            patientId,
            0,
            ((positionX*width)+(height * circleSize.values.elementAt(index))),
            ((positionY*height)+(height * circleSize.values.elementAt(index))),
            (tapPosition.dx),
            ((tapPosition.dy)-(height * 0.1)),
            (circleSize.values.elementAt(index)),
          );
        },
        child: Container(
          height: height * 1,
          width: width * 1,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.1,
                width: width * 1,
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
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
                    const StartMessage(
                      gameName: 'Target Game',
                      description: "Tap as many targets as you can in the given 30 seconds. Tap continue to begin and submit when you are done."
                    ),
                    TextButton(
                      onPressed: (){
                        timer!.cancel();
                        Get.to(const HomePage());
                      },
                      child: Text("Submit",
                      style: TextStyle(
                          fontSize: (width/Responsive.designWidth) * 30,
                          color: const Color.fromARGB(166, 207, 207, 11),
                          ),
                      )
                    ),
                  ],
                ),
              ),
              Center(
                child: (second>=0) ? Text(second.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (width/Responsive.designWidth) * 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ) : Text("0",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (width/Responsive.designWidth) * 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
              ),
              (second>=0) ? GestureDetector(
                //behavior: HitTestBehavior.translucent,
                onTapUp: (TapUpDetails details) {
                  debugPrint('Container Position: (${(positionX*width)+(height * circleSize.values.elementAt(index))} ${(positionY*height)+(height * circleSize.values.elementAt(index))})');
                  Offset tapPosition = details.globalPosition;
                  debugPrint("Tap Position Inside: (${tapPosition.dx}, ${(tapPosition.dy)-(height * 0.1)})");
                  TargetGameServices.targetGameDataFirebase(
                    patientId,
                    1,
                    ((positionX*width)+(height * circleSize.values.elementAt(index))),
                    ((positionY*height)+(height * circleSize.values.elementAt(index))),
                    (tapPosition.dx),
                    ((tapPosition.dy)-(height * 0.1)),
                    (circleSize.values.elementAt(index)),
                  );
                  getRandomPosition();
                  setState(() {});
                  
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: height * circleSize.keys.elementAt(index),
                  width: height * circleSize.keys.elementAt(index),
                  margin: EdgeInsets.only(left: (width * positionX),top: height * positionY),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),     
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: height * (circleSize.keys.elementAt(index)-0.03),
                      width: height * (circleSize.keys.elementAt(index)-0.03),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow,
                      ),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: height * (circleSize.keys.elementAt(index)-0.06),
                          width: height * (circleSize.keys.elementAt(index)-0.06),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}