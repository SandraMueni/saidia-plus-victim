import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:victim_app/AllScreens/loginScreen.dart';
import 'package:victim_app/AllScreens/mainscreen.dart';
import 'package:victim_app/main.dart';
import 'package:victim_app/AllWidgets/progressDialog.dart';

// ignore: must_be_immutable
class RegistrationScreen extends StatelessWidget
{

  static const String idScreen = "register";
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController insuranceTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 40.0,),
              Text(
                "Saidia Plus+",
                style: TextStyle(fontSize: 40.0,
                    fontFamily: "Poppins-Bold",
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30.0,),
              Text(
                "Register as a Victim",
                style: TextStyle(fontSize: 24.0,
                    fontFamily: "Poppins-Regular",
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 5.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Enter your name",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: "Name",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),

                    SizedBox(height: 5.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),

                    SizedBox(height: 5.0,),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Enter your phone number",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: "Phone",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),

                    SizedBox(height: 5.0,),
                    TextField(
                      controller: insuranceTextEditingController,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Enter your insurance number",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: "Insurance Number",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),

                    SizedBox(height: 5.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),

                    SizedBox(height: 30.0,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Container(
                        height: 55.0,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                fontSize: 22.0, fontFamily: "Poppins-Bold"),
                          ),
                        ),
                      ),
                      onPressed: ()
                      {
                        if(nameTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("Name is required!", context);
                        }
                        else if(!emailTextEditingController.text.contains("@"))
                        {
                          displayToastMessage("Email address is not Valid.", context);
                        }
                        else if(phoneTextEditingController.text.length != 10)
                        {
                          displayToastMessage("Phone Number must contain 10 digits.", context);
                        }
                        else if(insuranceTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("Insurance details are required!", context);
                        }
                        else if(passwordTextEditingController.text.length < 6)
                        {
                          displayToastMessage("Password must be at least 6 Characters.", context);
                        }
                        else
                        {
                          registerNewVictim(context);
                        }
                      },
                    ),
                  ],
                ),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Already have an Account? Login Here",
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewVictim(BuildContext context) async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Registering, Please wait...",);
        }
    );

    final User firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if(firebaseUser != null) //victim created
        {
      //victim user info to database
      Map victimDataMap = {
        "victim_name": nameTextEditingController.text.trim(),
        "victim_email": emailTextEditingController.text.trim(),
        "victim_contact": phoneTextEditingController.text.trim(),
        "victim_insurance": insuranceTextEditingController.text.trim(),
      };

      victimsRef.child(firebaseUser.uid).set(victimDataMap);
      displayToastMessage("Congratulations, your account has been created.", context);

      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
    }
    else
    {
      Navigator.pop(context);
      //error occurred - display error msg
      displayToastMessage("New victim account has not been created.", context);
    }
  }
}

displayToastMessage(String message, BuildContext context)
{
  Fluttertoast.showToast
    (msg: message,);
}
