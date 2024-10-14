import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuro_task_android/pages/homepage.dart';
import 'package:neuro_task_android/pages/splash_screen.dart';


class GrandFatherPassageServices {

  static Future<void> sendAudioToDatabase (String filePath) async{
  try {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference ref = storage.ref().child('videos/GrandfatherPassage-1002-$patientemail-${DateTime.now()}.aac'); // Use a unique filename
    final UploadTask uploadTask = ref.putFile(File(filePath));

    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    FirebaseFirestore.instance.collection("Grandfather Passage - 1002 - $patientemail").doc(DateTime.now().toString()).set({
      'game_id' : '1002',
      'patient_id' : patientId.toString(),
      'device_time' : DateTime.now().toString(),
      'audio' : downloadUrl,
    });
    debugPrint('Audio uploaded to Firebase Storage: $downloadUrl');
    Get.to(const HomePage());

    // Handle successful upload here (e.g., store downloadURL in database)
  } on FirebaseException catch (e) {
    debugPrint('Firebase Storage error: $e');
    // Handle upload errors here
  }

  }
}