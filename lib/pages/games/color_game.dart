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
import 'package:neuro_task_android/services/color_game_services.dart';
import 'package:neuro_task_android/ui/message/start_message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ColorGame extends StatefulWidget {
  const ColorGame({super.key});

  @override
  State<ColorGame> createState() => _ColorGameState();
}

class _ColorGameState extends State<ColorGame> {

  Map<String,Color> colorMap = {
    "Red" : Colors.yellow,
    "Green" : Colors.blue,
    "Blue" : Colors.brown,
    "Yellow" : Colors.green,
    "Orange" : Colors.red,
    "Pink" : Colors.orange,
    "Purple" : Colors.purple,
    "Brown" : Colors.black,
    "Black" : Colors.pink,
  };

  List<String> textColors = [
    "Yellow",
    "Blue",
    "Brown",
    "Green",
    "Red",
    "Orange",
    "Purple",
    "Black",
    "Pink",
    "Yellow",
  ];

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
                    Text("Color Game",
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
                      child: Text("Say aloud the color of the following words.Not the word itself.Tap continue to begin and submit when you are done.",
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
                        deviceTime = DateTime.now();
                        startTimer();
                        _startRecording();
                        _startSubRecording();
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

  double positionX = 0.0;
  double positionY= 0.0;
  Random random = Random();
  
  void getRandomPosition(){
    positionX = (0 + random.nextDouble() * (0.7 - 0));
    positionY = (0.1 + random.nextDouble() * (0.8 - 0.1));
  }



  int secondCount = 0;
  int index = 0;
  int currentIndex = 0;
  int intervalTime = 3;
  DateTime? deviceTime;
  DateTime? disapearTime;
  double screenHeight = 0.0,screenWidth = 0.0;

  void startTimer(){
    Timer.periodic(const Duration(seconds: 1), (timer) { 
      secondCount++;

      if(secondCount % intervalTime == 0){
        disapearTime = DateTime.now();
        currentIndex = -1;
        if(index < colorMap.length){
          index++;
          _stopSubRecording().whenComplete((){
            ColorGameServices.colorGameDataToFirebase(deviceTime!,disapearTime!,(positionX*screenWidth),(positionY*screenHeight),colorMap.keys.elementAt(index-1),textColors[index-1],intervalTime);
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
          if(index<colorMap.length){
            currentIndex = index;
            getRandomPosition();
            deviceTime = DateTime.now();
            setState(() {});
          }
        });
      }
    });
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
      ColorGameServices.sendAudioToDatabase(_filePath!);
    }
    setState(() {});
  }

  Future<void> _stopSubRecording() async {
    await _recorder2!.stopRecorder();
    debugPrint('Recording saved to: $_filePath2');
    setState(() {
      isRecording2 = false;
    });
  }
  
  String speechTotext = '';
  int success = 0;
  Future<void> speechToTextConvertion() async{
    for(int i=0;i<=8;i++){
      String apiKey = "0a8bc449c65e40b5b9e4cbfd553ba7dd56ae805f";
      Deepgram deepgram = Deepgram(apiKey);
      File audioFile = File('/storage/emulated/0/Android/data/com.example.neuro_task/files/subRecording$i.aac');
      String json  = (await deepgram.transcribeFromFile(audioFile)) as String;
      Map<String, dynamic> data = jsonDecode(json);
      speechTotext = data['results']['channels'][0]['alternatives'][0]['transcript'];
      if(speechTotext.toLowerCase().contains(textColors[i].toLowerCase())){
        success = 1;
      }
      else{
        success = 0;
      }
      ColorGameServices.colorGameSpeechToTextData(i, speechTotext, success);
    }
  }

  double height = 0.0;
  double width = 0.0;

  @override
  void initState() {
    _initialize();
    _initializeSubRecording();
    getRandomPosition();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startMessage();
    });
    super.initState();
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = Responsive.screenHeight(context);
    width = Responsive.screenWidth(context);
    screenHeight = height;
    screenWidth = width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                  gameName: 'Color Game',
                  description: "Say aloud the color of the following words.Not the word itself.Tap continue to begin and submit when you are done."
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
          //Text(voiceToText),
          (currentIndex!=-1)? Padding(
            padding: EdgeInsets.only(left: (width * positionX),top: height * positionY),
            child: Text(colorMap.keys.elementAt(currentIndex),
              style: TextStyle(
                color: colorMap.values.elementAt(currentIndex),
                fontSize: (width/Responsive.designWidth) * 50,
              ),
            ),
          ): const Text(""),
        ],
      )
    );
  }
}