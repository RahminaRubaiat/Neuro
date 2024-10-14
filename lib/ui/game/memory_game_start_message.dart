import 'package:flutter/material.dart';
import 'package:neuro_task_android/constant/my_text.dart';
import 'package:neuro_task_android/providers/memory_game_functions.dart';

class MemoryGameStartMessage{
  static startMessage(BuildContext context){
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const MyText(text: "Memory Game", size: 20, bold: true, color: Colors.black,height: 0.05,width: 1),
          actions: [
            TextButton(
              onPressed: (){
                MemoryGameFunctions.findTime();
                //GameInfo.gameInfo(patientId.toString(), email.toString(), MemoryGameFunctions.formattedTime, '1001', 'Memory Game');
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