// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:neuro_task/constant/my_text.dart';
// import 'package:neuro_task/providers/memory_game_functions.dart';
// import 'package:neuro_task/pages/homepage.dart';
// import 'package:neuro_task/services/game_info.dart';

// class TraceShapeStartMessage{
//   static startMessage(BuildContext context){
//     return showDialog(
//       context: context, 
//       builder: (context) {
//         return AlertDialog(
//           title: MyText(text: "Trace Shape", size: 50.sp, overflow: false, bold: true, color: Colors.black),
//           actions: [
//             TextButton(
//               onPressed: (){
//                 MemoryGameFunctions.findTime();
//                 GameInfo.gameInfo(patientId.toString(), email.toString(), MemoryGameFunctions.formattedTime, '3001', 'Trace Shape');
//                 Navigator.pop(context);
//               }, 
//               child: MyText(text: "OK", size: 40.sp, overflow: false, bold: false, color: Colors.deepPurple),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }