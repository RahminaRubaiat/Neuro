import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:deepgram_speech_to_text/deepgram_speech_to_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:neuro_task_android/constant/responsive.dart';
import 'package:neuro_task_android/pages/homepage.dart';
import 'package:neuro_task_android/services/picture_test_services.dart';
import 'package:neuro_task_android/ui/message/start_message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PictureTest extends StatefulWidget {
  const PictureTest({super.key});

  @override
  State<PictureTest> createState() => _PictureTestState();
}

class _PictureTestState extends State<PictureTest> {

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
                    Text("Picture Test",
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
                      child: Text("Say aloud the single word that best corresponds to the picture shown. Tap continue to start and submit when you are done.",
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
                        _startRecording();
                        _startSubRecording();
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
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<String> pictureList = [
    "assets/images/banana.jpg",
    "assets/images/piano.jpg",
    "assets/images/giraffe.jpg",
    "assets/images/flamingo.jpg",
    "assets/images/strawbery.jpg",
    "assets/images/tricycle.jpg",
    "assets/images/umbrella2.jpg",
    "assets/images/diamond.jpg",
    "assets/images/tomato.png",
    "assets/images/elephant.jpg",
    "assets/images/pinaple.png",
    "assets/images/calculator.jpg",
    "assets/images/cangaroo.jpg",
  ];

  List<String> pictureName = [
    'Banana',
    'Piano',
    'girafee',
    'Flamingo',
    'Strawbery',
    'TriCycle',
    'Umbrella',
    'Diamond',
    'Tomato',
    'Elephant',
    'Pinaple',
    'Calculator',
    'Cangaroo',
  ];

  int secondCount = 0;
  int index = 0;
  int currentIndex = 0;
  int intervalTime = 3;
  DateTime? deviceTime;
  DateTime? disapearTime;
  double screenHeight = 0.0,screenWidth = 0.0;
  int second = 51;

  void startTimer(){
    Timer.periodic(const Duration(seconds: 1), (timer) { 
      secondCount++;
      setState(() {
        second--;
      });

      if(secondCount % intervalTime == 0){
        disapearTime = DateTime.now();
        currentIndex = -1;
        if(index < pictureList.length){
          index++;
           _stopSubRecording().whenComplete((){
            //ColorGameServices.colorGameDataToFirebase(deviceTime!,disapearTime!,(positionX*screenWidth),(positionY*screenHeight),colorMap.keys.elementAt(index-1),textColors[index-1],intervalTime);
            PictureTestServices.pictureTestDataToFirebase(deviceTime!, disapearTime!, (positionX*screenWidth), (positionY*screenHeight), pictureName[index-1], intervalTime);
            value++;
            _startSubRecording();
          });
        }
        else{
          timer.cancel();
        }
        setState(() {});
        Future.delayed(const Duration(seconds: 1),(){
          secondCount--;

          if(index<pictureList.length){
            currentIndex = index;
            getRandomPosition();
            deviceTime = DateTime.now();
            setState(() {});
          }
        });
      }
    });
  }

  double positionX = 0.0;
  double positionY= 0.0;
  Random random = Random();
  void getRandomPosition(){
    positionX = (0 + random.nextDouble() * (0.6 - 0));
    positionY = (0.1 + random.nextDouble() * (0.6 - 0.1));
  }

  //Voice record
 FlutterSoundRecorder? _recorder;
 FlutterSoundRecorder? _recorder2;
 String? _filePath;
 String? _filePath2;
 bool isRecording = false;
 bool isRecording2 = false;
 int value = 0;

 Future<void> _initialize() async {
    _recorder = FlutterSoundRecorder();
    await Permission.microphone.request();
    await Permission.storage.request();
    await _recorder!.openRecorder();
  }

  Future<void> _initializeSubRecording() async {
    _recorder2 = FlutterSoundRecorder();
    await _recorder2!.openRecorder();
  }

  Future<void> _startRecording() async {
    if(!isRecording){
      final externalDir = await getExternalStorageDirectory();
      _filePath = '${externalDir!.path}/recording.aac';
      await _recorder!.startRecorder(toFile: _filePath, codec: Codec.aacMP4,);
      setState(() {
        isRecording = true;
      });
    }
  }

  Future<void> _startSubRecording() async {
    if(!isRecording2){
      final externalDir = await getExternalStorageDirectory();
      _filePath2 = '${externalDir!.path}/subRecording${value.toString()}.aac';
      await _recorder2!.startRecorder(toFile: _filePath2, codec: Codec.aacMP4,);
      setState(() {
        isRecording2 = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    debugPrint('Recording saved to: $_filePath');
    if(_filePath != null && _filePath!.isNotEmpty){
      PictureTestServices.sendAudioToDatabase(_filePath!);
    }
    setState(() {});
  }

  Future<void> _stopSubRecording() async {
    await _recorder2!.stopRecorder();
    debugPrint('Sub Recording saved to: $_filePath2');
    setState(() {
      isRecording2 = false;
    });
  }
  
  String speechTotext = '';
  int success = 0;
  Future<void> speechToTextConvertion() async{
    for(int i=0;i<=12;i++){
      String apiKey = "0a8bc449c65e40b5b9e4cbfd553ba7dd56ae805f";
      Deepgram deepgram = Deepgram(apiKey);
      File audioFile = File('/storage/emulated/0/Android/data/com.example.neuro_task/files/subRecording$i.aac');
      String json  = (await deepgram.transcribeFromFile(audioFile)) as String;
      Map<String, dynamic> data = jsonDecode(json);
      speechTotext = data['results']['channels'][0]['alternatives'][0]['transcript'];
      if(speechTotext.toLowerCase().contains(pictureName[i].toLowerCase())){
        success = 1;
      }
      else{
        success = 0;
      }
     // ColorGameServices.colorGameSpeechToTextData(i, speechTotext, success);
     PictureTestServices.pictureTestSpeechToTextData(i, speechTotext, success);
    }
  }


  @override
  void initState() {
    super.initState();
    _initialize();
    _initializeSubRecording();
    getRandomPosition();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startMessage();
    });
  }

  double height = 0.0, width = 0.0;

  @override
  Widget build(BuildContext context) {
    height = Responsive.screenHeight(context);
    width = Responsive.screenWidth(context);
    return Scaffold(
      body: Container(
        height: height * 1,
        width: width * 1,
        color: Colors.white,
        child: Column(
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
                    gameName: 'Picture Test',
                    description: "Say aloud the single word that best corresponds to the picture shown. Tap continue to start and submit when you are done."
                  ),
                  TextButton(
                    onPressed: (){
                      _stopRecording();
                      speechToTextConvertion();
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
            (second>=0 && (currentIndex!=-1)) ? Container(
              height: height * 0.2,
              width: width * 0.4,
              margin: EdgeInsets.only(left: (width * positionX),top: height * positionY),
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage(pictureList[currentIndex]),
                  fit: BoxFit.contain,
                ),
              ),
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}