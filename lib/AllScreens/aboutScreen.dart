import 'package:flutter/material.dart';
import 'package:victim_app/AllScreens/mainscreen.dart';

class AboutScreen extends StatefulWidget
{
  static const String idScreen = "about";

  @override
  _MyAboutScreenState createState() => _MyAboutScreenState();
}

class _MyAboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Container(
              height: 150,
              child: Center(
                child: Image.asset('images/ambulance.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, left: 24, right: 24),
              child: Column(
                children: <Widget>[
                  Text(
                    'Saidia Plus+', style: TextStyle(fontSize: 30, fontFamily: 'Poppins-Regular'),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Learn about the types of ambulances', style: TextStyle(fontSize: 18.5, fontFamily: 'Poppins-Bold'),
                  ),
                  SizedBox(height: 20),
                  //Type-1 Ambulance
                  Text(
                    'Type-1 Ambulance', style: TextStyle(fontSize: 18.5, fontFamily: 'Poppins-Bold',),
                  ),

                  //Type-2 Ambulance
                  Text(
                    'Type-2 Ambulance', style: TextStyle(fontSize: 18.5, fontFamily: 'Poppins-Bold',),
                  ),

                  //Type-3 Ambulance
                  Text(
                    'Type-3 Ambulance', style: TextStyle(fontSize: 18.5, fontFamily: 'Poppins-Bold',),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),
            FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
                },
                child: const Text(
                    'Go Back',
                    style: TextStyle(
                        fontSize: 18, color: Colors.black
                    )
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0))
            ),
          ],
        ));
  }
}