// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuro_task_android/constant/my_text.dart';
import 'package:neuro_task_android/constant/responsive.dart';
import 'package:neuro_task_android/pages/authentication/sign_up.dart';
import 'package:neuro_task_android/services/login_service.dart';
import 'package:neuro_task_android/ui/text_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController email = TextEditingController();
  TextEditingController resetEmail = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: height * 1,
          width: width * 1,
          decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("assets/images/login.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: height * 0.25),
              const MyText(text: "Welcome To Neuro Task", size: 30, bold: true, color: Colors.blue,height: 0.05,width: 1),
              SizedBox(height:height * 0.01),
              MyTextField(width: 0.85, text: "Email", icon: Icons.mail, controller: email, check: false),
              SizedBox(height: height * 0.01),
              MyTextField(width: 0.85, text: "Password", icon: Icons.key, controller: password, check: true),
              SizedBox(height: height * 0.01),
              InkWell(
                onTap: (){
                  setState(() {
                    LoginService().firebaseLogin(email.text, password.text).whenComplete((){
                      setState(() {
                        
                      });
                    });
                  });
                },
                child: Container(
                  height: height * 0.06,
                  width: width * 0.83,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular((width/Responsive.designWidth) * 50))
                  ),
                  child: (LoginService.isLoading) ? const Center(child: CircularProgressIndicator(color: Colors.white,)) :
                  const MyText(text: "Login", size: 30, bold: false, color: Colors.white,height: 0.04,width: 0.2),
                ),
              ),
              SizedBox(height:height * 0.005),
              TextButton(
                onPressed: (){
                  Get.defaultDialog(
                    title:  "Reset Your Password",
                    content: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          child: MyTextField(width: 0.7, text: "Enter Your Email", icon: Icons.email, controller: resetEmail, check: false)),
                      ],
                    ),
                    confirm: TextButton(
                      onPressed: (){
                        if(resetEmail.text.isEmpty){
                           Get.snackbar(
                              "Neuro Task",
                              "Please enter your email and try again",
                              snackPosition: SnackPosition.TOP,
                            );
                          Navigator.pop(context);
                        }
                        else{
                          FirebaseAuth.instance.sendPasswordResetEmail(email: resetEmail.text.toString()).then((value){
                            Get.snackbar(
                              "Neuro Task",
                              "We have send you a email to reset password. Please check it.",
                              snackPosition: SnackPosition.TOP,
                            );
                            Navigator.pop(context);
                            resetEmail.clear();
                          }).onError((error, stackTrace){
                            Get.snackbar(
                              "Neuro Task", 
                              "Server is busy",
                              snackPosition: SnackPosition.TOP
                            );
                          });
                        }
                      }, 
                      child: const MyText(text: "Send", size: 20,bold: false, color: Colors.green,height: 0.05,width: 1,), 
                    ),
                    cancel: TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: const MyText(text: "Cancel", size: 20, bold: false, color: Colors.red,height: 0.05,width: 1,), 
                    ),
                  );
                }, 
                child: const MyText(text: "Forgot Password?", size: 20, bold: true, color: Colors.green,height: 0.04,width: 0.6,),
              ),
              TextButton(
                onPressed: (){
                  Get.to(const SignUp());
                }, 
                child: const MyText(text: "Don't have any account? Signup", size: 20, bold: false, color: Colors.deepPurple,height: 0.04,width: 0.7,),
              ),
              //SizedBox(height: height * 0.005),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     MyIcon(icon: Icons.local_hospital, color: Colors.lightBlue, size: 90.sp),
              //     MyIcon(icon: Icons.medical_information, color: Colors.lightBlue, size: 90.sp),
              //     MyIcon(icon: Icons.mobile_screen_share, color: Colors.lightBlue, size: 90.sp),
              //   ],
              // ),
              //SizedBox(height:height * 0.005),
              const MyText(text: " Neuro Task - 2023  © copyright Mosaic Lab", size: 20, bold: false, color: Colors.black,height: 0.05,width: 0.8,),
              //SizedBox(height:height * 0.01),
            ],
          ),
        ),
      )
    );
  }
}