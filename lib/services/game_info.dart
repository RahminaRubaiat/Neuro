
// import 'package:http/http.dart' as http;

// class GameInfo{
//   static Future<void> gameInfo(String patientId,String email,String startTime,String gameId,String gameName) async{
//     var ip = IP.ip;
//     var url = 'http://$ip/Neuro_Task/game_info.php';
//     try{
//       var res = await http.post(Uri.parse(url),body: {
//         'p_id' : patientId,
//         'email' : email,
//         'start_time' : startTime,
//         'game_id' : gameId,
//         'game_name' : gameName,
//       });
//       if(res.body=='success'){
//         // ignore: avoid_print
//         print('Success');
//       }
//       else{
//         // ignore: avoid_print
//         print('errors');
//       }
//     }
//     catch(e){
//       // ignore: avoid_print
//       print(e);
//     }

//   }
// }