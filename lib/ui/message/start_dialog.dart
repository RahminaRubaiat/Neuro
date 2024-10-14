import 'package:flutter/material.dart';
import 'package:neuro_task_android/constant/responsive.dart';

class StartDialog{
  
  Future startDialog(BuildContext context,String gameName,String description) async{
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
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
                    Text(gameName,
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
                      child: Text(description,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: (width/Responsive.designWidth) * 30,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    // Text("Continue",
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     fontSize: (width/Responsive.designWidth) * 40,
                    //     fontWeight: FontWeight.bold,
                    //     color: const Color.fromARGB(166, 207, 207, 11),
                    //   ),
                    // ),
                    // SizedBox(height: height * 0.01),
                    InkWell(
                      onTap:(){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.keyboard_arrow_up,
                        size: (width/Responsive.designWidth) * 50,
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
}