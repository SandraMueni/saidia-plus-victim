import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:victim_app/AllScreens/searchScreen.dart';
import 'package:victim_app/AllWidgets/Divider.dart';
import 'package:victim_app/AllWidgets/progressDialog.dart';
import 'package:victim_app/Assistants/assistantMethods.dart';
import 'package:victim_app/DataHandler/appData.dart';
import 'package:victim_app/Models/directionDetails.dart';

import '../configMaps.dart';
import 'loginScreen.dart';

class MainScreen extends StatefulWidget
{
  static const String idScreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin
{
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  DirectionDetails tripDirectionDetails;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap =0;

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  double tripDetailsContainerHeight = 0;
  double requestTripContainerHeight = 0;
  double searchContainerHeight = 300.0;
  double paramedicDetailsContainerHeight = 0;

  bool drawerOpen = true;

  DatabaseReference victimRequestRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AssistantMethods.getCurrentOnlineVictimInfo();
  }

  void saveVictimRequest() {
    victimRequestRef = FirebaseDatabase.instance.reference().child("Victim Requests").push();

    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map pickUpLocMap =
    {
      "latitude": pickUp.latitude.toString(),
      "longitude": pickUp.longitude.toString(),
    };

    Map dropOffLocMap =
    {
      "latitude": dropOff.latitude.toString(),
      "longitude": dropOff.longitude.toString(),
    };

    Map tripInfoMap =
    {
      "paramedic_id": "waiting",
      "payment_method": "cash",
      "pickup_coordinates": pickUpLocMap,
      "dropoff_coordinates": dropOffLocMap,
      "time_created": DateTime.now().toString(),
      "victim_name": victimCurrentInfo.victim_name,
      "victim_contact": victimCurrentInfo.victim_contact,
      "pickup_address": pickUp.placeName,
      "dropoff_address": dropOff.placeName,
    };

    victimRequestRef.set(tripInfoMap);
    /*rideStreamSubscription = victimRequestRef.onValue.listen((event){
      if(event.snapshot.value == null)
      {
        return;
      }
      if(event.snapshot.value["ambulance_details"] != null)
      {
        statusRide = event.snapshot.value["ambulance_details"].toString();
      }
      if(event.snapshot.value["paramedic_name"] != null)
      {
        setState(() {
          paramedicName = event.snapshot.value["paramedic_name"].toString();
        });
      }
      if(event.snapshot.value["paramedic_phone"] != null)
      {
        setState(() {
          paramedicPhone = event.snapshot.value["paramedic_phone"].toString();
        });
      }
      if(statusRide == "accepted")
      {
        displayParamedicDetailsContainer();
      }
    });*/
  }

  void cancelTripRequest()
  {
    victimRequestRef.remove();
    /*setState(() {
      state = "normal";
    });*/
  }

  void displayRequestTripContainer()
  {
    setState(() {
      requestTripContainerHeight = 250.0;
      tripDetailsContainerHeight = 0;
      bottomPaddingOfMap = 230.0;
      drawerOpen = true;
    });

    saveVictimRequest();
  }

  resetApp()
  {
    setState(() {
      drawerOpen = true;
      searchContainerHeight = 300.0;
      tripDetailsContainerHeight = 0.0;
      requestTripContainerHeight = 0;
      bottomPaddingOfMap = 230.0;

      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoordinates.clear();
    });

    locatePosition();
  }

  void displayTripDetailsContainer() async
  {
    await getPlaceDirection();

    setState(() {
      searchContainerHeight = 0;
      tripDetailsContainerHeight = 240.0;
      bottomPaddingOfMap = 230.0;
      drawerOpen = false;
    });
  }

  //Retrieve Victim's Current Location
  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your address :: " + address);

  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Saidia Plus+"),
        ),
        drawer: Container(
          color: Colors.white,
          width: 255.0,
          child: Drawer(
            child: ListView(
              children: [
                Container(
                  height: 165.0,
                  child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/user_icon.png", height: 65.0, width: 65.0,),
                        SizedBox(width: 16.0,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Profile Name", style: TextStyle(
                              fontSize: 16.0, fontFamily: "Poppins-Bold"),),
                            SizedBox(height: 10.0,),
                            Text("Visit Profile"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                DividerWidget(),

                SizedBox(height: 12.0,),

                //Drawer Body Constraints
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text("History", style: TextStyle(fontSize: 15.0),),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Visit Profile", style: TextStyle(fontSize: 15.0),),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text("About", style: TextStyle(fontSize: 15.0),),
                ),
                GestureDetector(
                  onTap: ()
                  {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                  },
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Sign Out", style: TextStyle(fontSize: 15.0),),
                  ),
                ),
              ],
            ),
          ),
        ),

      body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              polylines: polylineSet,
              markers: markersSet,
              circles: circlesSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {
                  bottomPaddingOfMap = 300.0;
                });

                locatePosition();
              },
            ),

            //HamburgerButton for Drawer
            Positioned(
              top: 38.0,
              left: 22.0,
              child: GestureDetector(
                onTap: ()
                {
                  if(drawerOpen)
                  {
                    scaffoldKey.currentState.openDrawer();
                  }
                  else
                  {
                    resetApp();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 6.0,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon((drawerOpen) ?Icons.menu : Icons.close, color: Colors.black,),
                    radius: 20.0,
                  ),
                ),
              ),
            ),

            //Search Ui
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
                child: AnimatedSize(
                  vsync: this,
                  curve: Curves.bounceIn,
                  duration: new Duration(milliseconds: 160),
                  child: Container(
                    height: searchContainerHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 16.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6.0),
                          Text("Don't panic,", style: TextStyle(fontSize: 12.0),),
                          Text("Request for help.", style: TextStyle(fontSize: 20.0, fontFamily: "Poppins-Bold"),),
                          SizedBox(height: 20.0),

                          GestureDetector(
                            onTap: () async
                            {
                              var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));

                              if(res == "obtainDirection")
                              {
                                displayTripDetailsContainer();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 6.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.7, 0.7),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.search, color: Colors.blue,),
                                    SizedBox(width: 10.0,),
                                    Text("Search Destination")
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 24.0,),
                          Row(
                            children: [
                              Icon(Icons.pin_drop, color: Colors.grey,),
                              SizedBox(width: 12.0, height: 10.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      Provider.of<AppData>(context).pickUpLocation != null
                                          ? Provider.of<AppData>(context).pickUpLocation.placeName
                                          : "Add emergency location"
                                  ),
                                  SizedBox(height: 4.0,),
                                  Text("Your current emergency location", style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 10.0,),

                          DividerWidget(),

                          SizedBox(height: 16.0,),

                          Row(
                            children: [
                              Icon(Icons.home, color: Colors.grey,),
                              SizedBox(width: 12.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Add Home"),
                                  SizedBox(height: 4.0,),
                                  Text("Your current residential address",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12.0),),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            //Trip Details User Interface
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: new Duration(milliseconds: 160),
                child: Container(
                  height: tripDetailsContainerHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7,0.7),
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 17.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.tealAccent[100],
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset("images/ambulance.png", height: 70.0, width: 80.0,),
                                SizedBox(width: 16.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ambulance", style: TextStyle(fontSize: 18.0, fontFamily: "Poppins-Bold"),
                                    ),
                                    Text(
                                      ((tripDirectionDetails != null) ?tripDirectionDetails.distanceText : ''), style: TextStyle(fontSize: 16.0, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Expanded(child: Container(),),
                                Text(
                                  ((tripDirectionDetails != null) ? '\Ksh. ${AssistantMethods.calculateFares(tripDirectionDetails)}' : ''), style: TextStyle(fontFamily: "Poppins-Bold",),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20.0),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.moneyCheckAlt, size: 18.0, color: Colors.black54,),
                              SizedBox(width: 16.0),
                              Text("Cash"),
                              SizedBox(width: 6.0,),
                              Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 16.0,),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.0,),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: RaisedButton(
                            onPressed: ()
                            {
                             /* setState(() {
                                state = "requesting";
                              });*/
                              displayRequestTripContainer();
                              /*availableParamedics = GeoFireAssistant.nearbyAvailableParamedicsList;
                              searchNearestParamedic();*/
                            },
                            color: Theme.of(context).accentColor,
                            child: Padding(
                              padding: EdgeInsets.all(17.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Request", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                                  Icon(FontAwesomeIcons.ambulance, color: Colors.white, size: 26.0,),
                                ],
                              ),
                            ),
                          ) ,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            //Request & Cancel User Interface
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0.5,
                      blurRadius: 16.0,
                      color: Colors.black54,
                      offset: Offset(0.7,0.7),
                    ),
                  ],
                ),
                height: requestTripContainerHeight,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      SizedBox(height: 12.0,),

                      SizedBox(
                        width: double.infinity,
                        child: ColorizeAnimatedTextKit(
                            onTap: () {
                              print("Tap Event");
                            },
                            text: [
                              "Requesting an Ambulance...",
                              "Please wait...",
                              "Finding a Paramedic...",
                            ],
                            textStyle: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Poppins-Italic",
                            ),
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlue,
                            ],
                            textAlign: TextAlign.center,
                            alignment: AlignmentDirectional.topStart
                        ),
                      ),

                      SizedBox(height: 22.0,),

                      GestureDetector(
                        onTap: ()
                        {
                          cancelTripRequest();
                          resetApp();
                        },
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26.0),
                            border: Border.all(width: 2.0, color: Colors.grey[300]),
                          ),
                          child: Icon(Icons.close, size: 26.0,),
                        ),
                      ),

                      SizedBox(height: 10.0,),

                      Container(
                        width: double.infinity,
                        child: Text("Cancel Request", textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0),),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        )
    );
  }

  Future<void> getPlaceDirection() async
  {
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Please wait...",)
    );

    var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);

    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);

    print("This is Encoded Points ::");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();

    if(decodedPolyLinePointsResult.isNotEmpty)
    {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng)
      {
        pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if(pickUpLatLng.latitude > dropOffLatLng.latitude  &&  pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    }
    else if(pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude), northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    }
    else if(pickUpLatLng.latitude > dropOffLatLng.latitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude), northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    }
    else
    {
      latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(title: initialPos.placeName, snippet: "My location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: finalPos.placeName, snippet: "DropOff location"),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.deepPurple,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }

}
