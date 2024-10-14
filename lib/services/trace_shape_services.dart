// import 'package:get/get.dart';
// import 'package:neuro_task/constant/ip.dart';
// import 'package:http/http.dart' as http;
// import 'package:neuro_task/pages/homepage.dart';

// class TraceShapeService{
//   static var ip = IP.ip;
//   static List<String> lineStartTime = [];
//   static List<String> lineEndTime = [];
//   static List<String> startLocation = [];
//   static List<String> endLocation = [];
//   static List<String> startRegion = [];
//   static List<String> endRegion = [];
//   static List<String> accuracy = [];

//   static Future<void> traceShapeData() async{
//     for(int i=0;i<lineStartTime.length;i++){
//       // print(lineStartTime[i]);
//       // print(lineEndTime[i]);
//       // print(startLocation[i]);
//       // print(endLocation[i]);
//       // print(startRegion[i]);
//       // print(endRegion[i]);
//       // print(accuracy[i]);
//       try{
//         var url = 'http://$ip/Neuro_task/trace_shape.php';
//         var res = await http.post(Uri.parse(url),body: {
//           'p_id' : patientId,
//           'game_id' : '3001',
//           'line_start_time' : lineStartTime[i],
//           'line_end_time' : lineEndTime[i],
//           'start_location' : startLocation[i],
//           'end_location' : endLocation[i],
//           'start_region' : startRegion[i],
//           'end_region' : endRegion[i],
//           'accuracy' : accuracy[i],
//         });
//         if(res.body == 'success'){
//           Get.to(const HomePage());
//           // ignore: avoid_print
//           print('success');
//         }
//         else{
//           // ignore: avoid_print
//           print('error');
//         }
//       }
//       catch(e){
//         // ignore: avoid_print
//         print(e);
//       }
//     }
//     reset();
//   }

//   static void reset(){
//     lineStartTime.clear();
//     lineEndTime.clear();
//     startLocation.clear();
//     endLocation.clear();
//     startRegion.clear();
//     endRegion.clear();
//     accuracy.clear();
//   }
// }