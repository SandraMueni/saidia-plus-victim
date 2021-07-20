import 'package:flutter/material.dart';
import '../configMaps.dart';
import 'mainscreen.dart';

class ProfileTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              victimCurrentInfo.victimName,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins-Regular',
              ),
            ),

            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
              ),
            ),

            SizedBox(height: 40.0,),

            InfoCard(
              text: victimCurrentInfo.victimContact,
              icon: Icons.phone,
              onPressed: () async {
                print("this is phone.");
              },
            ),

            InfoCard(
              text: victimCurrentInfo.victimEmail,
              icon: Icons.email,
              onPressed: () async {
                print("this is email.");
              },
            ),

            FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
                },
                child: const Text(
                    'Go Back',
                    style: TextStyle(
                        fontSize: 18, color: Colors.white,
                    )
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0))
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatefulWidget
{
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard({this.text, this.icon, this.onPressed,});

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            widget.icon,
            color: Colors.black87,
          ),
          title: Text(
            widget.text,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16.0,
              fontFamily: 'Poppins-Bold',
            ),
          ),
        ),
      ),
    );
  }
}

