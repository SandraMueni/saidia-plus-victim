import 'package:firebase_database/firebase_database.dart';

class Victims
{
  String victim_id;
  String victim_contact;
  String victim_email;
  String victim_insurance;
  String victim_name;


  Victims({this.victim_id, this.victim_contact, this.victim_email, this.victim_insurance, this.victim_name});

  Victims.fromSnapshot(DataSnapshot dataSnapshot)
  {
    victim_id = dataSnapshot.key;
    victim_contact = dataSnapshot.value["victim_contact"];
    victim_email = dataSnapshot.value["victim_email"];
    victim_insurance = dataSnapshot.value["victim_insurance"];
    victim_name = dataSnapshot.value["victim_name"];
  }
}

