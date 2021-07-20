import 'package:victim_app/AllScreens/registrationScreen.dart';
import 'package:victim_app/AllWidgets/progressDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:victim_app/AllScreens/mainscreen.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget
{
  static const String idScreen = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();

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
              SizedBox(height: 80.0,),
              Text(
                "Saidia Plus+",
                style: TextStyle(fontSize: 40.0, fontFamily: "Poppins-Bold", color: Colors.white),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 70.0,),
              Text(
                "Login as a Victim",
                style: TextStyle(fontSize: 24.0, fontFamily: "Poppins-Regular", color: Colors.white),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 10.0,),
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

                    SizedBox(height: 10.0,),
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

                    SizedBox(height: 40.0,),
                    ElevatedButton(
                      child: Container(
                        height: 55.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 22.0, fontFamily: "Poppins-Bold"),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if(!emailTextEditingController.text.contains("@"))
                        {
                          displayToastMessage("Email address is not Valid.", context);
                        }
                        else if(passwordTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("Password is mandatory.", context);
                        }
                        else if(passwordTextEditingController.text.length < 6)
                        {
                          displayToastMessage("Password must be at least 6 Characters.", context);
                        }
                        else
                        {
                          loginAndAuthenticateVictim(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              TextButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Do not have an Account? Register Here",
                  style: TextStyle(fontSize: 15.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateVictim(BuildContext context) async
  {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Authenticating, Please wait...",);
        }
    );

    final User firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if(firebaseUser != null)
    {
      victimsRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if(snap.value != null)
        {
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("Successfully logged in.", context);
        }
        else
        {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("No record exists for this victim. Please create new account.", context);
        }
      });
    }
    else
    {
      Navigator.pop(context);
      displayToastMessage("Error Occurred, can not be Signed-in.", context);
    }
  }
}

