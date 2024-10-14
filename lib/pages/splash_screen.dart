import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuro_task_android/constant/responsive.dart';
import 'package:neuro_task_android/pages/authentication/login.dart';
import 'package:neuro_task_android/pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: prefer_typing_uninitialized_variables
var patientemail;
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    getValidation().whenComplete((){
      Timer(const Duration(seconds: 2), () { 
        (patientemail == null) ? Get.to(const Login()) : Get.to(const HomePage());
      });
    });
    super.initState();
  }

  Future getValidation() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var getEmail = sharedPreferences.getString('email');
    patientemail = getEmail;
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height * 1,
          width: width * 1,
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: height * 0.4,
                child: Material(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular((width/Responsive.designWidth)*100)),
                  child: FittedBox(
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.2),
                      child: Image.asset('assets/images/splash_screen_main.png'),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: height * 0.55,
                left: 0,
                right: 0,
                bottom: 0,
                child: const Material(
                  color: Colors.deepPurple,
                ),
              ),
              Positioned(
                top: height * 0.55,
                left: 0,
                right: 0,
                bottom: 0,
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular((width/Responsive.designWidth)*100)),
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Text("Neuro Task",
                        style: TextStyle(
                          fontSize: (width/Responsive.designWidth)*50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}