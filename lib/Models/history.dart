import 'package:firebase_database/firebase_database.dart';

class History
{
  String paymentMethod;
  String timeCreated;
  String status;
  String charges;
  String dropoffAddress;
  String pickupAddress;

  History({this.paymentMethod, this.timeCreated, this.status, this.charges, this.dropoffAddress, this.pickupAddress});

  History.fromSnapshot(DataSnapshot snapshot)
  {
    paymentMethod = snapshot.value["payment_method"];
    timeCreated = snapshot.value["time_created"];
    status = snapshot.value["status"];
    charges = snapshot.value["charges"];
    dropoffAddress = snapshot.value["dropoff_address"];
    pickupAddress = snapshot.value["pickup_address"];
  }
}