import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:device_screen_recorder/device_screen_recorder.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flip_card/flip_card.dart';
import 'package:neuro_task_android/constant/responsive.dart';
import 'package:neuro_task_android/pages/homepage.dart';
import 'package:neuro_task_android/pages/splash_screen.dart';
import 'package:neuro_task_android/providers/memory_game_functions.dart';
import 'package:neuro_task_android/services/memory_game_service.dart';
import 'package:neuro_task_android/ui/message/start_message.dart';
import 'package:path_provider/path_provider.dart';


class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {

  String front = "assets/images/flower.png";
  //Yellow Circle
  GlobalKey<FlipCardState> element1Card = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> element2Card = GlobalKey<FlipCardState>();
  //Two Rectangle
  GlobalKey<FlipCardState> element3Card = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> element4Card = GlobalKey<FlipCardState>();
  //Triangle
  GlobalKey<FlipCardState> element5Card = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> element6Card = GlobalKey<FlipCardState>();
  //Polygon
  GlobalKey<FlipCardState> element7Card = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> element8Card = GlobalKey<FlipCardState>();
  //Rectangle
  GlobalKey<FlipCardState> element9Card = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> element10Card = GlobalKey<FlipCardState>();
  //Circle Blue
  GlobalKey<FlipCardState> element11Card = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> element12Card = GlobalKey<FlipCardState>();

  int cardCount=0;
  List<int> cardValue = [];
  List<GlobalKey<FlipCardState>> cards = [];
  List<bool> item = [false,false,false,false,false,false,false,false,false,false,false,false];
  int success = 0;
  
  late CameraController _cameraController;
  // ignore: unused_field
  bool _isLoading = true;
  bool _isRecording = false;

  _initCamera() async {
  final cameras = await availableCameras();
  final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
  _cameraController = CameraController(front, ResolutionPreset.max);
  await _cameraController.initialize();
  setState(() => _isLoading = false);
  _startRecord();
 }

 _stopRecord() async {
  if (_isRecording) {
    final file = await _cameraController.stopVideoRecording();
    setState(() => _isRecording = false);
    DateTime time = DateTime.now();
    String fileNames = "Memory Game - 1001 - Camera Record Video - $patientemail - ${time.toString()}";
    final destinationPaths = 'videos/$fileNames';

    final firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref(destinationPaths);

      try {
        await storageReference.putFile(File(file.path));
        final downloadURL = await storageReference.getDownloadURL();
        MemoryGameService.memoryGameVideoLink(downloadURL);
        debugPrint('Video uploaded to Firebase Storage. Download URL: $downloadURL');
        
      } catch (e) {
        debugPrint('Error uploading video to Firebase Storage: $e');
      }



    final downloadDirectory = await getExternalStorageDirectory();
    if (downloadDirectory == null) {
      return;
    }
    final downloadFolder = Directory('${downloadDirectory.path}/video');
    if (!await downloadFolder.exists()) {
      await downloadFolder.create(recursive: true);
    }

    // Generate a unique filename for the video
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String fileName = 'video_$currentTime.mp4';

    // Create the destination path in the "Download" folder
    final String destinationPath = '${downloadFolder.path}/$fileName';

    // Copy the video file to the "Download" folder
    final videoFile = File(file.path);
    await videoFile.copy(destinationPath);
    // ignore: avoid_print
    print(destinationPath);
    
    //Get.to(VideoPage(filePath: file.path));
  } 
}

_startRecord() async{
    await _cameraController.prepareForVideoRecording();
    await _cameraController.startVideoRecording();
    setState(() => _isRecording = true);
    // ignore: avoid_print
    print('starting..');
}

Future<void> startScreenRecording() async{
  await DeviceScreenRecorder.startRecordScreen();
}

Future<void> stopScreenRecording() async{
  var file = await DeviceScreenRecorder.stopRecordScreen();

  DateTime time = DateTime.now();
  String fileNames = "Memory Game - 1001 - Screen Record Video- $patientemail - ${time.toString()}";
  final destinationPaths = 'videos/$fileNames';

  final firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref(destinationPaths);
  
  try {
    File files = File(file.toString());
    await storageReference.putFile(File(files.path));
    final downloadURL = await storageReference.getDownloadURL();
    MemoryGameService.memoryGameScreenVideoLink(downloadURL);
    debugPrint('Video uploaded to Firebase Storage. Download URL: $downloadURL');
  } catch (e) {
      debugPrint('Error uploading video to Firebase Storage: $e');
  }

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
                    Text("Memory Game",
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
                      child: Text("Flip cards (two at a time) to find all matching pairs of images in as few taps as possible. Tap continue to start and submit when you are done.",
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
  
  
  @override
  void initState() {
    _initCamera();
    startScreenRecording();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startMessage();
    });
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
  
  double height = 0.0,width = 0.0;

  @override
  Widget build(BuildContext context) {
    height = Responsive.screenHeight(context);
    width = Responsive.screenWidth(context);
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap:(){
            MemoryGameFunctions.findTime();
            MemoryGameService.memoryGameDataFirebase('1001',patientId, MemoryGameFunctions.formattedTime, success, MemoryGameFunctions.screenPosition, 0, 0);
          },
          onTapDown: (TapDownDetails details){
            MemoryGameFunctions.screenPositionValue(details, context);
          },
          child: Container(
            height: height * 1,
            width: width * 1,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: height * 0.1,
                  width: width * 1,
                  color: Colors.white,
                  child: Row(
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
                      // Container(
                      //   height: height * 0.05,
                      //   width: width * 0.1,
                      //   color: Colors.white,
                      //   child: (_isLoading) ? const Center(
                      //     child: CircularProgressIndicator(),
                      //   ) : CameraPreview(
                      //     _cameraController,
                      //   ),
                      // ),
                      // Container(
                      //   height: height * 0.08,
                      //   width: width * 0.08,
                      //   decoration: const BoxDecoration(
                      //     color: Colors.deepPurple,
                      //     shape: BoxShape.circle
                      //   ),
                      //   child: Center(
                      //     child: (_isRecording)?const Icon(Icons.stop,color: Colors.white,) : const Icon(Icons.fiber_manual_record,color: Colors.white),
                      //   ),
                      // ),
                      const StartMessage(
                        gameName: 'Memory Game',
                        description: "Flip cards (two at a time) to find all matching pairs of images in as few taps as possible. Tap continue to start and submit when you are done."
                      ),
                      TextButton(
                        onPressed: (){
                          _stopRecord();
                          stopScreenRecording();
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
                //Flip Card
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTapUp: (TapUpDetails details) {
                           MemoryGameFunctions.cardPositionValue(details,context);
                           MemoryGameFunctions.findTime();
                          },
                          onTap: (){ 
                            if(element3Card.currentState!.isFront == true && cardCount!=2 && item[0]==false){
                              cardCount++;
                              element3Card.currentState!.toggleCard();
                              cardValue.add(1);
                              cards.add(element3Card);
                              item[0]=true;
                              if(cardCount==2){
                                successCard();
                              }
                              MemoryGameService.memoryGameDataFirebase('1001',patientId, MemoryGameFunctions.formattedTime, success,MemoryGameFunctions.screenPosition, 1, MemoryGameFunctions.cardPosition);
                            }
                          },
                          child: FlipCard( 
                            key: element3Card,
                            flipOnTouch: false,
                            onFlip: (){
                              
                            },
                            front: customCard(front), 
                            back: customCard('assets/images/TwoRectangle.png'),
                          ),
                        ),
                      GestureDetector(
                        onTapUp: (TapUpDetails details) {
                            MemoryGameFunctions.cardPositionValue(details,context);
                            MemoryGameFunctions.findTime();
                          },
                          onTap: (){
                            if(element1Card.currentState!.isFront == true && cardCount!=2 && item[1]==false){
                              cardCount++;
                              element1Card.currentState!.toggleCard();
                              cardValue.add(2);
                              cards.add(element1Card);
                              item[1]=true;
                              if(cardCount==2){
                              successCard();
                              }
                              MemoryGameService.memoryGameDataFirebase('1001',patientId, MemoryGameFunctions.formattedTime, success, MemoryGameFunctions.screenPosition, 2, MemoryGameFunctions.cardPosition);
                            }
                          },
                        child: FlipCard(
                          key: element1Card,
                          flipOnTouch: false,
                          onFlip: (){
                            
                          },
                          front: customCard(front), 
                          back: customCard('assets/images/CircleYellow.png'),
                        ),
                      ),
                      GestureDetector(
                        onTapUp: (TapUpDetails details) {
                            MemoryGameFunctions.cardPositionValue(details,context);
                            MemoryGameFunctions.findTime();
                          },
                          onTap: (){
                            
                            if(element2Card.currentState!.isFront == true && cardCount!=2 && item[2]==false){
                              cardCount++;
                              element2Card.currentState!.toggleCard();
                              cardValue.add(102);
                              cards.add(element2Card);
                              item[2]=true;
                              if(cardCount==2){
                               successCard();
                              }
                              MemoryGameService.memoryGameDataFirebase('1001',patientId, MemoryGameFunctions.formattedTime, success, MemoryGameFunctions.screenPosition, 3, MemoryGameFunctions.cardPosition); 
                            }
                          },
                        child: FlipCard(
                          key: element2Card,
                          flipOnTouch: false,
                          onFlip: (){
                            
                          },
                          front: customCard(front), 
                          back: customCard('assets/images/CircleYellow.png'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTapUp: (TapUpDetails details) {
                            MemoryGameFunctions.cardPositionValue(details,context);
                            MemoryGameFunctions.findTime();
                          },
                          onTap: (){
                            if(element5Card.currentState!.isFront == true && cardCount!=2 && item[3]==false){
                              cardCount++;
                              element5Card.currentState!.toggleCard();
                              cardValue.add(3);
                              cards.add(element5Card);
                              item[3]=true;
                              if(cardCount==2){
                              successCard();
                              }
                              MemoryGameService.memoryGameDataFirebase('1001',patientId, MemoryGameFunctions.formattedTime, success, MemoryGameFunctions.screenPosition, 4, MemoryGameFunctions.cardPosition);
                            }
                          },
                        child: FlipCard(
                          key: element5Card,
                          flipOnTouch: false,
                          onFlip: (){
                            
                          },
                          front: customCard(front), 
                          back: customCard('assets/images/Triangle.png'),
                        ),
                      ),
                      GestureDetector(
                        onTapUp: (TapUpDetails details) {
                            MemoryGameFunctions.cardPositionValue(details,context);
                            MemoryGameFunctions.findTime();
                          },
                          onTap: (){
                            if(element7Card.currentState!.isFront == true && cardCount!=2 && item[4]==false){
                              cardCount++;
                              element7Card.currentState!.toggleCard();
                              cardValue.add(4);
                              cards.add(element7Card);
                              item[4]=true;
                              if(cardCount==2){
                              successCard();
                              }
                              MemoryGameService.memoryGameDataFirebase('1001',patientId, MemoryGameFunctions.formattedTime, success, MemoryGameFunctions.screenPosition, 5, MemoryGameFunctions.cardPosition);
                            }
                          },
                        child: FlipCard(
                          key: element7Card,
                          flipOnTouch: false,
                          onFlip: (){
                            
                          },
                          front: customCard(front), 
                          back: customCard('assets/images/Polygon.png'),
                        ),
                      ),
                      GestureDetector(
                        onTapUp: (TapUpDetails details) {
                            MemoryGameFunctions.cardPositionValue(details,context);
                            MemoryGameFunctions.findTime();
                          },
                          onTap: (){
                            if(element9Card.currentState!.isFront == true && cardCount!=2 && item[5]==false){
                              cardCount++;
                              element9Card.currentState!.toggleCard();
                              cardValue.add(5);
                              cards.add(element9Card);
                              item[5]=true;
                              if(cardCount==2){
                              successCard();
                              }
                              MemoryGameService.memoryGameDataFirebase('1001',patientId, MemoryGameFunctions.formattedTime, success, MemoryGameFunctions.screenPosition, 6, MemoryGameFunctions.cardPosition);
                            }
                          },
                        child: FlipCard(
                          key: element9Card,
                          flipOnTouch: false,
                          onFlip: (){
                            
                          },
                          front: customCard(front), 
                          back: customCard('assets/images/Rectangle.png'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTapUp: (TapUpDetails details) {
                            MemoryGameFunctions.cardPositionValue(details,context);
                            MemoryGameFunctions.findTime();
                          },
                          onTap: (){
                            if(element4Card.currentState!.isFront == true && cardCount!=2 && item[6]==false){
                              cardCount++;
                              element4Card.currentState!.toggleCard();
                              cardValue.add(101);
                              cards.add(element4Card);
                              item[6]=true;
                              if(cardCount==2){
                              successCard();
                             }
                             MemoryGameService.memoryGameDataFirebase('1001',patientId, MemoryGameFunctions.formattedTime, success, MemoryGameFunctions.screenPosition, 7, MemoryGameFunctions.cardPosition);
                            }
                          },
                        child: FlipCard(
                          key: element4Card,
                          flipOnTouch: false,
                          onFlip: (){
                            
                          },
                          front: customCard(front), 
                          back: customCard('assets/images/TwoRectangle.png'),
                        ),
                      ),
                      GestureDetector(
                        onTapUp: (TapUpDetails details) {
                            MemoryGameFunctions.cardPositionValue(details,context);
                            MemoryGameFunctions.findTime();
                          },
                          onTap: (){
                            if(element6Card.currentState!.isFront == true && cardCount!=2 && item[7]==false){
                              cardCount++;
                              element6Card.currentState!.toggleCard();
                              cardValue.add(103);
                              cards.add(element6Card);
                              item[7]=true;
                              if(cardCount==2){
                              successCard();
                              }
                              MemoryGameService.memoryGameDataFirebase('1001',patientId, MemoryGameFunctions.formattedTime, success, MemoryGameFunctions.screenPosition, 8, MemoryGameFunctions.cardPosition);
                            }
                          },
                        child: FlipCard(
                          key: element6Card,
                          flipOnTouch: false,
                          onFlip: (){
                            
                          },
                          front: customCard(front), 
                          back: customCard('assets/images/Triangle.png'),
                        ),
                      ),
                      GestureDetector(
                        onTapUp: (TapUpDetails details) {
                          MemoryGameFunctions.cardPositionValue(details,context);
                          MemoryGameFunctions.findTime();
                        },
                        onTap: (){
                          if(element11Card.currentState!.isFront == true && cardCount!=2 && item[8]==false){
                              cardCount++;
                              element11Card.currentState!.toggleCard();
                              cardValue.add(6);
                              cards.add(element11Card);
                              item[8]=true;
                              if(cardCount==2){
                              successCard();
                              }
                              MemoryGameService.memoryGameDataFirebase('1001',patientId, MemoryGameFunctions.formattedTime, success, MemoryGameFunctions.screenPosition, 9, MemoryGameFunctions.cardPosition);
                            }  
                        },
                        child: FlipCard(
                          key: element11Card,
                          flipOnTouch: false,
                          onFlip: (){
                           
                          },
                          front: customCard(front), 
                          back: customCard('assets/images/CircleBlue.png'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTapUp: (TapUpDetails details) {
                            MemoryGameFunctions.cardPositionValue(details,context);
                            MemoryGameFunctions.findTime();
                          },
                          onTap: (){
                           if(element10Card.currentState!.isFront == true && cardCount!=2 && item[9]==false){
                              cardCount++;
                              element10Card.currentState!.toggleCard();
                              cardValue.add(105);
                              cards.add(element10Card);
                              item[9]=true;
                              if(cardCount==2){
                              successCard();
                              }
                              MemoryGameService.memoryGameDataFirebase('1001',patientId, MemoryGameFunctions.formattedTime, success, MemoryGameFunctions.screenPosition, 10, MemoryGameFunctions.cardPosition);
                            }
                          },
                        child: FlipCard(
                          key: element10Card,
                          flipOnTouch: false,
                          onFlip: (){
                            
                          },
                          front: customCard(front), 
                          back: customCard('assets/images/Rectangle.png'),
                        ),
                      ),
                      GestureDetector(
                        onTapUp: (TapUpDetails details) {
                            MemoryGameFunctions.cardPositionValue(details,context);
                            MemoryGameFunctions.findTime();
                          },
                          onTap: (){
                           if(element12Card.currentState!.isFront == true && cardCount!=2 && item[10]==false){
                              cardCount++;
                              element12Card.currentState!.toggleCard();
                              cardValue.add(106);
                              cards.add(element12Card);
                              item[10]=true;
                              if(cardCount==2){
                              successCard();
                              }
                              MemoryGameService.memoryGameDataFirebase('1001',patientId, MemoryGameFunctions.formattedTime, success, MemoryGameFunctions.screenPosition, 11, MemoryGameFunctions.cardPosition);
                            }
                          },
                        child: FlipCard(
                          key: element12Card,
                          flipOnTouch: false,
                          onFlip: (){
                           
                          },
                          front: customCard(front), 
                          back: customCard('assets/images/CircleBlue.png'),
                        ),
                      ),
                      GestureDetector(
                        onTapUp: (TapUpDetails details) {
                            MemoryGameFunctions.cardPositionValue(details,context);
                            MemoryGameFunctions.findTime();
                          },
                          onTap: (){
                            if(element8Card.currentState!.isFront == true && cardCount!=2 && item[11]==false){
                              cardCount++;
                              element8Card.currentState!.toggleCard();
                              cardValue.add(104);
                              cards.add(element8Card);
                              item[11]=true;
                              if(cardCount==2){
                              successCard();
                              }
                              MemoryGameService.memoryGameDataFirebase('1001',patientId, MemoryGameFunctions.formattedTime, success, MemoryGameFunctions.screenPosition, 12, MemoryGameFunctions.cardPosition);
                            }
                          },
                        child: FlipCard(
                          key: element8Card,
                          flipOnTouch: false,
                          onFlip: (){
                            
                          },
                          front: customCard(front), 
                          back: customCard('assets/images/Polygon.png'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      )
    );
  }

  void successCard(){
    if((cardValue[0]-cardValue[1]).abs()!=100){
      try{
        Timer(const Duration(seconds: 1), () { 
        cards[0].currentState!.toggleCard();
        cards[1].currentState!.toggleCard();
        cards.clear();
        cardValue.clear();
        cardCount=0;
        for(int i=0;i<12;i++){
          item[i]=false;
        }
      });
      }
      catch(e){
        // ignore: avoid_print
        print(e);
      }
    }
    else{
      try{
        success++;
        setState(() {
          
        });
        cards.clear();
        cardValue.clear();
        cardCount=0;
      }
      catch(e){
        // ignore: avoid_print
        print(e);
      }
    }
  }
   Widget customCard(String path){
    return Container(
        margin: EdgeInsets.only(top: height * 0.01),
        height: height * 0.2,
        width: width * 0.3,  
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular((width/Responsive.designWidth) * 20)),
          border: Border.all(
            width: width * 0.005,
          )
        ),
        child: Image(
          height: height * 0.13,
          width: width * 0.23,
          image: AssetImage(path),
          fit: BoxFit.cover,
        ),
    );
  }
}