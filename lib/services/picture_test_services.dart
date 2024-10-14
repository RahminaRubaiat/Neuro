import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neuro_task_android/pages/homepage.dart';
import 'package:neuro_task_android/pages/splash_screen.dart';

class PictureTestServices{
 
  static List<String> docsName = [];

  static Future<void> pictureTestDataToFirebase(
      DateTime deviceTime,
      DateTime pictureDisappearTime,
      double picturePositionX,
      double picturePositionY,
      String pictureContent,
      int pictureChangeDuration,
    ) async{
    DateTime currentTime = DateTime.now();
    String deviceTimeForFirebase = DateFormat('HH:mm:ss').format(deviceTime);
    String textDisappearTimeForFirebase = DateFormat('HH:mm:ss').format(pictureDisappearTime);
    try{
      String doc = currentTime.toString();
      docsName.add('$doc - $patientId');
      FirebaseFirestore.instance.collection('Picture Test - 1006 - $patientemail').doc('$doc - $patientId').set({
        'Pateint Id' : patientId,
        'Device Time' : deviceTimeForFirebase,
        'Picture Appear Time' : deviceTimeForFirebase,
        'Picture Disappear Time' : textDisappearTimeForFirebase,
        'Picture Appear Location (x,y)' : '$picturePositionX , $picturePositionY',
        'Picture Content' : pictureContent,
        'Picture Change Duration' : pictureChangeDuration,
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

  static Future<void> pictureTestSpeechToTextData(int index,String speechTotext,int success) async{
    try{
      FirebaseFirestore.instance.collection('Picture Test - 1006 - $patientemail').doc(docsName[index]).update({
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
    final Reference ref = storage.ref().child('videos/Picture Test-1006-$patientemail-${DateTime.now()}.aac'); // Use a unique filename
    final UploadTask uploadTask = ref.putFile(File(filePath));

    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    FirebaseFirestore.instance.collection("Picture Test - 1006 - $patientemail - Video & Audio").doc(DateTime.now().toString()).set({
      'game_id' : '1006',
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