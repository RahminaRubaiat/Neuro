import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neuro_task_android/pages/homepage.dart';
import 'package:neuro_task_android/pages/splash_screen.dart';

class ColorGameServices{
 
  static List<String> docsName = [];

  static Future<void> colorGameDataToFirebase(
      DateTime deviceTime,
      DateTime textDisappearTime,
      double colorPositionX,
      double colorPositionY,
      String textContent,
      String textColor,
      int textChangeDuration,
    ) async{
    DateTime currentTime = DateTime.now();
    String deviceTimeForFirebase = DateFormat('HH:mm:ss').format(deviceTime);
    String textDisappearTimeForFirebase = DateFormat('HH:mm:ss').format(textDisappearTime);
    try{
      String doc = currentTime.toString();
      docsName.add('$doc - $patientId');
      FirebaseFirestore.instance.collection('Color Game - 1005 - $patientemail').doc('$doc - $patientId').set({
        'Pateint Id' : patientId,
        'Device Time' : deviceTimeForFirebase,
        'Text Appear Time' : deviceTimeForFirebase,
        'Text Disappear Time' : textDisappearTimeForFirebase,
        'Text appear Location (x,y)' : '$colorPositionX , $colorPositionY',
        'Text Content' : textContent,
        'Text Color' : textColor,
        //'Text from voice to text' : textFromSpeech,
        'Text_Change_Duration' : textChangeDuration,
        //'Success' : (textFromSpeech.toLowerCase().contains(textContent.toLowerCase()) || textFromSpeech.toLowerCase() == textContent.toLowerCase()) ? 1 : 0,
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

  static Future<void> colorGameSpeechToTextData(int index,String speechTotext,int success) async{
    try{
      FirebaseFirestore.instance.collection('Color Game - 1005 - $patientemail').doc(docsName[index]).update({
       'Success' : success,
       'Text from voice to text' : speechTotext,
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

  static Future<void> sendAudioToDatabase (String filePath) async{
  try {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference ref = storage.ref().child('videos/Color Game-1005-$patientemail-${DateTime.now()}.aac'); // Use a unique filename
    final UploadTask uploadTask = ref.putFile(File(filePath));

    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    FirebaseFirestore.instance.collection("Color Game - 1005 - $patientemail - Video & Audio").doc(DateTime.now().toString()).set({
      'game_id' : '1005',
      'patient_id' : patientId.toString(),
      'device_time' : DateTime.now().toString(),
      'audio' : downloadUrl,
    });
    debugPrint('Audio uploaded to Firebase Storage: $downloadUrl');

    // Handle successful upload here (e.g., store downloadURL in database)
  } on FirebaseException catch (e) {
    debugPrint('Firebase Storage error: $e');
    // Handle upload errors here
  }
  catch(error){
    debugPrint(error.toString());
  }

  }
}