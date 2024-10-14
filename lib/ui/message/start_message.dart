import 'package:flutter/material.dart';
import 'package:neuro_task_android/constant/responsive.dart';
import 'package:neuro_task_android/ui/message/start_dialog.dart';

class StartMessage extends StatefulWidget {
  final String gameName;
  final String description;
  const StartMessage({super.key, required this.gameName, required this.description});

  @override
  State<StartMessage> createState() => _StartMessageState();
}

class _StartMessageState extends State<StartMessage> {

  StartDialog startDialog = StartDialog();

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return InkWell(
      onTap: (){
        startDialog.startDialog(context,widget.gameName,widget.description);
      },
      child: Container(
        height: height * 0.2,
        width: width * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              spreadRadius: 2,
            )
          ]
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.02),
            Expanded(
              flex: 1,
              child: FittedBox(
                child: Text(widget.gameName,
                  style: TextStyle(
                    fontSize: (width/Responsive.designWidth) * 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FittedBox(
                child: Icon(Icons.keyboard_arrow_down_sharp,
                  size: (width/Responsive.designWidth) * 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}