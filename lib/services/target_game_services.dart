import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:neuro_task_android/pages/splash_screen.dart';

class TargetGameServices{
  static String  formattedTime = "";
  static Future<void> targetGameDataFirebase(var patientId,int success,double circleX,double circleY,double tapX,double tapY,double radius) async{
    DateTime currentTime = DateTime.now();
    formattedTime = DateFormat('HH:mm:ss').format(currentTime);
    try{
      FirebaseFirestore.instance.collection('Target Game - 1004 - $patientemail').doc('${currentTime.toString()} - $patientId').set({
        'game_id' : '1004',
        'p_id' : patientId,
        'device_time' : formattedTime,
        'success' : success.toString(),
        'tap location (x,y)' : '(${tapX.toString()} , ${tapY.toString()})',
        'circle location (x,y)' : '(${circleX.toString()} , ${circleY.toString()})',
        'radius of the circle' :  radius.toString(),
      }).then((value) => {
        // ignore: avoid_print
        print('seccess'),
      }).catchError((error)=>{
        // ignore: avoid_print
        print(error),
      });
    }
    catch(e){
      // ignore: avoid_print
      print(e);
    }
  }

  static Future<void> memoryGameVideoLink(String videoLink) async{
    DateTime time = DateTime.now();
    FirebaseFirestore.instance.collection('Games Video - $patientemail').doc('${time.toString()} - Memory Game').set({
      'Camera Video' : videoLink,
    });
  }

  static Future<void> memoryGameScreenVideoLink(String videoLink) async{
    DateTime time = DateTime.now();
    FirebaseFirestore.instance.collection('Games Video - $patientemail').doc('${time.toString()} - Memory Game').set({
      'Screen Record Video' : videoLink,
    });
  }
}