import 'package:firebase_database/firebase_database.dart';

class Victims
{
  String victimId;
  String victimContact;
  String victimEmail;
  String victimInsurance;
  String victimName;


  Victims({this.victimId, this.victimContact, this.victimEmail, this.victimInsurance, this.victimName});

  Victims.fromSnapshot(DataSnapshot dataSnapshot)
  {
    victimId = dataSnapshot.key;
    victimContact = dataSnapshot.value["victim_contact"];
    victimEmail = dataSnapshot.value["victim_email"];
    victimInsurance = dataSnapshot.value["victim_insurance"];
    victimName = dataSnapshot.value["victim_name"];
  }
}

