import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neuro_task_android/constant/my_text.dart';
import 'package:neuro_task_android/constant/responsive.dart';
import 'package:neuro_task_android/ui/game/narration_recording.dart';

class Narration extends StatefulWidget {
  const Narration({super.key});

  @override
  State<Narration> createState() => _NarrationState();
}

class _NarrationState extends State<Narration> {

  bool isStart = false;

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height * 1,
          width: width * 1,
          color: const  Color.fromARGB(255, 43, 43, 43),
          child: (isStart) ? const NarrationRecording()
           : Center(
            child: Container(
              height: height * 0.8,
              width: width * 1,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const MyText(text: "Narration", size: 30, bold: true, color: Colors.white,height: 0.05,width: 0.3),
                      Icon(
                        CupertinoIcons.speaker_2_fill,
                        size:  width * 0.08,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.1),
                  const MyText(text: "Read the sentence shown aloud", size:30, bold: false, color: Colors.white,height: 0.05,width: 0.7,),
                  SizedBox(height: height * 0.1),
                  ElevatedButton(
                    onPressed: (){
                      isStart = true;
                      setState(() {});
                    },
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.pink),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.015,horizontal: width * 0.08),
                      child: const MyText(text: "Begin Test", size: 30,bold: true, color: Colors.white,height: 0.05,width: 0.2,)),
                  ),
                ],
              ),
            ),
          ),
        ),  
      )
    );
  }
}