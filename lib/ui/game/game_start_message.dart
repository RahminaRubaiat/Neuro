import 'package:flutter/material.dart';
import 'package:neuro_task_android/constant/my_text.dart';

class GameStartMessage{
  static startMessage(BuildContext context,String title,String subTitle){
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: MyText(text: title, size: 20, bold: true, color: Colors.black,height: 0.05,width: 1),
          actions: [
            TextButton(
              onPressed: (){
                //MemoryGameFunctions.findTime();
                //GameInfo.gameInfo(patientId.toString(), email.toString(), MemoryGameFunctions.formattedTime, '1002', 'Grandfather Passage');
                Navigator.pop(context);
              }, 
              child: const MyText(text: "OK", size: 20, bold: false, color: Colors.deepPurple,height: 0.05,width: 0.05,),
            ),
          ],
        );
      },
    );
  }
}