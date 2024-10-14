// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuro_task_android/pages/homepage.dart';
import 'package:neuro_task_android/pages/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpService{

  // Future<void> signUp(String email,String password,String confirmPassword,String firstName, String lastName,String mobile,String birthDate,String ethincity,String gender) async{
    
  //   if(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || firstName.isEmpty || lastName.isEmpty || mobile.isEmpty || birthDate.isEmpty || ethincity.isEmpty || gender.isEmpty){
  //     Get.snackbar('Neuro Task', 'Please fill all the input box');
  //   }
  //   else if(!email.contains('@gmail.com')){
  //     Get.snackbar('Neuro Task', 'Invalid email address');
  //   }
  //   else if(password!=confirmPassword){
  //     Get.snackbar('Neuro Task', "Password and confirm password is not same");
  //   }
  //   else if(password.length<8){
  //     Get.snackbar('Neuro Task', "Weak Password");
  //   }
  //   else{
  //     var url = "http://$ip/Neuro_Task/sign_up.php";
  //       try{
  //         var res = await  http.post(Uri.parse(url),body: {
  //           'email' : email,
  //           'password' : password,
  //           'first_name' : firstName,
  //           'last_name' : lastName,
  //           'mobile_number' : mobile,
  //           'date_of_birth' : birthDate,
  //           'ethincity' : ethincity,
  //           'gender' : gender,
  //         });

  //         if(res.body== 'email already exist'){
  //           Get.snackbar('Neuro Task', 'Email already exist');
  //         }
  //         else if(res.body== 'error'){
  //           Get.snackbar('Neuro Task', 'Server Down');
  //         }
  //         else if(res.body=='success'){
  //           Get.snackbar('Neuro Task', 'Account creation sucessfull');
  //           Get.to(const HomePage());
  //         }
  //         else{
  //           Get.snackbar('Neuro Task', 'Error');
  //         }
  //       }
  //       catch(e){
  //         // ignore: avoid_print
  //         print(e);
  //       }
  //   }
  // }
  
  static bool isLoading = false;

  Future<void> firebaseSignUp(String email,String password,String confirmPassword,String firstName, String lastName,String mobile,String birthDate,String ethincity,String gender) async{
     DateTime currentTime = DateTime.now();
     int id = currentTime.microsecondsSinceEpoch;
    if(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || firstName.isEmpty || lastName.isEmpty || mobile.isEmpty || birthDate.isEmpty || ethincity.isEmpty || gender.isEmpty){
      Get.snackbar('Neuro Task', 'Please fill all the input box');
    }
    else if(!email.contains('@gmail.com')){
      Get.snackbar('Neuro Task', 'Invalid email address');
    }
    else if(password!=confirmPassword){
      Get.snackbar('Neuro Task', "Password and confirm password is not same");
    }
    else if(password.length<8){
      Get.snackbar('Neuro Task', "Weak Password");
    }
    else{
      isLoading = true;
      try{
        // ignore: unused_local_variable
        UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('email', email);
        patientemail = email;
        Get.snackbar('Neuro Task', 'Your Account Creation Successfull');
        Get.to(const HomePage());
        //user.user!.sendEmailVerification();

        FirebaseFirestore.instance.collection(email).doc(id.toString()).set({
          'Patient Id' : id.toString(),
          'First Name' : firstName,
          'Last Name' : lastName,
          'Date Of Birth (DD-MM-YYYY)' : birthDate,
          'Mobile Number' : mobile,
          'Ethincity' : ethincity,
          'Gender' : gender
        });
      }on FirebaseAuthException catch(e){
        if(e.code == 'weak-password'){
          Get.snackbar('Weak Password', 'Your Password Is Weak');
        }
        else if(e.code == 'email-already-in-use'){
          Get.snackbar('Reused Email', 'Your Email Is Already Used',
        );
        }
      } catch (error) {
        Get.snackbar('Error', 'FoodFrenzy Server is Down');
      }finally{
        isLoading = false;
      }
    }
  }

  Future<void> signUpWithFirebase(BuildContext context, email,String password,String fullName,String birthDate,String activity) async{
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    DateTime currentTime = DateTime.now();
    int id = currentTime.microsecondsSinceEpoch;
    if(email.isEmpty || password.isEmpty  || fullName.isEmpty  || birthDate.isEmpty  || activity.isEmpty){
      Get.snackbar('Neuro Task', 'Please fill all the input box');
    }
    else if(password.length<8){
      Get.snackbar('Neuro Task', "Weak Password");
    }
    else{
      isLoading = true;
      try{
        // ignore: unused_local_variable
        UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        //user.user!.sendEmailVerification();

        FirebaseFirestore.instance.collection(email).doc(id.toString()).set({
          'Patient Id' : id.toString(),
          'Full Name' : fullName,
          'Patient Email' : email,
          'Date Of Birth (DD-MM-YYYY)' : birthDate,
          'Activity' : activity,
        }).then((value){
          sharedPreferences.setString('email', email);
          patientemail = email;
          Get.snackbar('Neuro Task', 'Your Account Creation Successfull');
          navigator!.pop(context);
          Get.to(const HomePage());
        });
      }on FirebaseAuthException catch(e){
        if(e.code == 'weak-password'){
          Get.snackbar('Weak Password', 'Your Password Is Weak');
        }
        else if(e.code == 'email-already-in-use'){
          Get.snackbar('Reused Email', 'Your Email Is Already Used',
        );
        }
      } catch (error) {
        Get.snackbar('Error', 'FoodFrenzy Server is Down');
      }finally{
        navigator!.pop(context);
        isLoading = false;
      }
    }
    navigator!.pop(context);
  }

}