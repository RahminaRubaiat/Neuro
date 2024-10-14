import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neuro_task_android/constant/responsive.dart';
import 'package:neuro_task_android/services/signup_service.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController diagnosis = TextEditingController();
  //TextEditingController lastName = TextEditingController();
  // TextEditingController gender = TextEditingController();
  //TextEditingController number = TextEditingController();
  //TextEditingController confirmPassword = TextEditingController();
  double height=0.0, width = 0.0;
  List<String> items = ["BasketBall","Cycling","Boxing","Drumming","None","",""];
  int selectedItem = 2;
  bool isVisible = false;
  SignUpService signUpService = SignUpService();

  @override
  Widget build(BuildContext context) {
    height = Responsive.screenHeight(context);
    width = Responsive.screenWidth(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: height * 1,
          width: width * 1,
          decoration: const BoxDecoration(
            color: Colors.white,
            // image: DecorationImage(
            //   image: AssetImage("assets/images/signup_image.jpg"),
            //   fit: BoxFit.fill,
            // ),
          ),
          child:SingleChildScrollView(
            child: Column(
                children: [
                  Text("Neuro Task - SignUp",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (width / Responsive.designWidth) * 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Container(
                    height: height * 0.55,
                    width: width * 1,
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          myCustomTextFormField(email, "Email",false,Icons.mail),
                          SizedBox(height: height * 0.01,),
                          myCustomTextFormField(password, "Password",true,Icons.password),
                          SizedBox(height: height * 0.01,),
                          myCustomTextFormField(fullName, "Full Name",false,Icons.person),
                          SizedBox(height: height * 0.01,),
                          //myCustomTextFormField(lastName, "Last Name",false,Icons.person),
                          myCustomTextFormField(diagnosis, "Diagnosis",false,Icons.medical_services),
                          SizedBox(height: height * 0.01,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                            child: TextFormField(
                              controller: birthDate,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: height * 0.02, 
                                  horizontal: width * 0.04,
                                ),
                                prefixIcon: Icon(Icons.calendar_month,size: ((width / Responsive.designWidth) * 30)),
                                hintText: "Date Of Birth",
                                hintStyle: TextStyle(
                                fontSize: (width/Responsive.designWidth) * 30,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular((width/Responsive.designWidth) * 20)),
                                )
                              ),
                              readOnly: true,
                              onTap: (){
                                selectDate();
                              },
                            ),
                          ),
                          SizedBox(height: height * 0.2),
                        ],
                      ),
                    ),
                  ),
                  Text("Select Activity",
                   style: TextStyle(
                    fontSize: (width/Responsive.designWidth) * 30,
                    fontWeight: FontWeight.normal,
                   ),
                  ),
                  SizedBox(height: height * 0.02),
                  Container(
                    height: height * 0.15,
                    width: width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: CupertinoPicker(
                      itemExtent: height * 0.05, 
                      looping: false,
                      onSelectedItemChanged: (int value){
                        selectedItem = value;
                      }, 
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedItem,
                      ),
                      children: [
                        Text("BasketBall",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: (width/Responsive.designWidth) * 40,
                          ),
                        ),
                        Text("Cycling",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: (width/Responsive.designWidth) * 40,
                          ),
                        ),
                        Text("Boxing",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: (width/Responsive.designWidth) * 40,
                          ),
                        ),
                        Text("Drumming",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: (width/Responsive.designWidth) * 40,
                          ),
                        ),
                        Text("None",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: (width/Responsive.designWidth) * 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      signUpService.signUpWithFirebase(context, email.text, password.text, fullName.text, birthDate.text, items[selectedItem]);
                    }, 
                    child: Text("Start",
                      style: TextStyle(
                        fontSize: (width/Responsive.designWidth) * 40,
                      ),
                    ),
                  ),
                ],
              ),
          ),
          ),
        ),
    );
  }

  Widget myCustomTextFormField(TextEditingController controller,String title,bool check,IconData icon){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: TextFormField(
        controller: controller,
        obscureText: (check && isVisible) ? true : false,
        style: TextStyle(
          fontSize: (width/Responsive.designWidth) * 30,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: height * 0.02, 
            horizontal: width * 0.04,
          ),
          prefixIcon: Icon(icon,size: ((width / Responsive.designWidth) * 30)),
          suffixIcon: (check && isVisible) ? InkWell(
            onTap: (){
              setState(() {
                isVisible = !isVisible;
              });
            },
            child: Icon(Icons.visibility,size: ((width / Responsive.designWidth) * 30))) : 
            (check && !isVisible) ? InkWell(
              onTap: (){
                setState(() {
                  isVisible = !isVisible;
                });
              },
              child: Icon(Icons.visibility_off,size: ((width / Responsive.designWidth) * 30))) : null,
          hintText: title,
          hintStyle: TextStyle(
            fontSize: (width/Responsive.designWidth) * 30,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular((width/Responsive.designWidth) * 20)),
          )
        ),
      ),
    );
  }

  Future<void> selectDate() async{
    DateTime ? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), 
      lastDate: DateTime(2100),
    );
    
    if(picked != null){
      setState(() {
        birthDate.text = picked.toString().split(" ")[0];
      });
    }
  }
}