import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:victim_app/Assistants/requestAssistant.dart';
import 'package:victim_app/DataHandler/appData.dart';
import 'package:victim_app/Models/address.dart';
import 'package:victim_app/Models/allVictims.dart';
import 'package:victim_app/Models/directionDetails.dart';
import '../configMaps.dart';
import 'package:http/http.dart' as http;

class AssistantMethods {
  static Future<String> searchCoordinateAddress(Position position, context) async
  {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      placeAddress = response["results"][0]["formatted_address"];

      Address victimPickUpAddress = new Address();
      victimPickUpAddress.longitude = position.longitude;
      victimPickUpAddress.latitude = position.latitude;
      victimPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(victimPickUpAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails>obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async
  {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition
        .latitude},${initialPosition.longitude}&destination=${finalPosition
        .latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    //in terms USD
    double timeTraveledFare = (directionDetails.durationValue / 60) * 0.30;
    double distancTraveledFare = (directionDetails.distanceValue / 1000) * 0.30;
    double totalFareAmount = timeTraveledFare + distancTraveledFare;

    //Local Currency
    //1$ = 108 Kshs
    double totalLocalAmount = totalFareAmount * 108;

    return totalLocalAmount.truncate();
  }

  static void getCurrentOnlineVictimInfo() async
  {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String victimId = firebaseUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("Victims").child(victimId);

    reference.once().then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null)
      {
        victimCurrentInfo = Victims.fromSnapshot(dataSnapShot);
      }
    });
  }

  static double createRandomNumber(int num) {
    var random = Random();
    int radNumber = random.nextInt(num);
    return radNumber.toDouble();
  }

  static sendNotificationToParamedic(String token, context, String victim_request_id) async
  {
    var destination = Provider.of<AppData>(context, listen: false).dropOffLocation;
    Map<String, String> headerMap =
    {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };

    Map notificationMap =
    {
      'body': 'DropOff Address, ${destination.placeName}',
      'title': 'New Emergency Request'
    };

    Map dataMap =
    {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'victim_request_id': victim_request_id,
    };

    Map sendNotificationMap =
    {
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
      "to": token,
    };

    var res = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
  }

}