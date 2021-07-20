import 'package:firebase_auth/firebase_auth.dart';
import 'Models/allVictims.dart';

String mapKey = "AIzaSyCQST2iIBCjl5_n8-qQMLkwnOkHzBIhBrY";

//Global Variables

User firebaseUser;

Victims victimCurrentInfo;

int paramedicRequestTimeOut = 30;
String statusTrip = "";
String tripStatus = "A paramedic is on the way";
String ambulanceDetailsParamedic = "";
String paramedicName = "";
String paramedicContact = "";

String ambulanceTripType="";

String serverToken = "key=AAAA7XBNr-0:APA91bGxbA5t8UK-vESYTwaVivTkl7nLLr0DQWKsxaKxTp3ytWTDBnhxyPB4cqLzvJr6myJN_FpfaTYiYDIYMyt03tAOoB2Mnv5EkvDP1GWJsx9RSiGueDunYsrC7oiYWNMUkSNOtryG";
