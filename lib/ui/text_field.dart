import 'package:flutter/material.dart';
import 'package:neuro_task_android/constant/responsive.dart';

class MyTextField extends StatefulWidget {
  final double width;
  final String text;
  final IconData icon;
  final bool check;
  final TextEditingController controller;
  const MyTextField({super.key,required this.width, required this.text, required this.icon, required this.controller, required this.check});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {

  final _formKey = GlobalKey<FormState>();
  bool obSecure = true;

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return Container(
      height: height * 0.1,
      width: width * widget.width,
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Form(
        key: _formKey,
        child: TextFormField(
          validator: (value){
            if(value == null || value.isEmpty){
              return 'Please add some text';
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon,
              color: Colors.black,
              //weight: (width/Responsive.designWidth) * 20,
            ),
            suffixIcon: GestureDetector(
              onTap: (){
                obSecure  = !obSecure;
                setState(() { 
                });
              },
              child: Icon(
                (widget.check==true) ? Icons.remove_red_eye : Icons.arrow_back,size: width * 0.07,
                color: (widget.check==true) ? Colors.black : Colors.transparent,
              ),
            ),
            labelText: widget.text,
            labelStyle: const TextStyle(
              color: Colors.black,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(
              borderSide:  const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular((width/Responsive.designWidth) * 30)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular((width/Responsive.designWidth) * 30)),
            ),
          ),
          controller: widget.controller,
          obscureText: (widget.check==true && obSecure==true) ? true : false,
        ),
      ),
    );
  }
}