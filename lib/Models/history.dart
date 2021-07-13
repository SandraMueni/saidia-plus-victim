import 'package:firebase_database/firebase_database.dart';

class History
{
  String payment_method;
  String time_created;
  String status;
  String charges;
  String dropoff_address;
  String pickup_address;

  History({this.payment_method, this.time_created, this.status, this.charges, this.dropoff_address, this.pickup_address});

  History.fromSnapshot(DataSnapshot snapshot)
  {
    payment_method = snapshot.value["payment_method"];
    time_created = snapshot.value["time_created"];
    status = snapshot.value["status"];
    charges = snapshot.value["charges"];
    dropoff_address = snapshot.value["dropoff_address"];
    pickup_address = snapshot.value["pickup_address"];
  }
}