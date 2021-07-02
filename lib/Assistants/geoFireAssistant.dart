import 'package:victim_app/Models/nearbyAvailableParamedics.dart';

class GeoFireAssistant
{
  static List<NearbyAvailableParamedics> nearbyAvailableParamedicsList = [];

  static void removeParamedicFromlist(String key)
  {
    int index = nearbyAvailableParamedicsList.indexWhere((element) => element.key == key);
    nearbyAvailableParamedicsList.removeAt(index);
  }

  static void updateParamedicByLocation(NearbyAvailableParamedics paramedic)
  {
    int index = nearbyAvailableParamedicsList.indexWhere((element) => element.key == paramedic.key);
    nearbyAvailableParamedicsList[index].latitude = paramedic.latitude;
    nearbyAvailableParamedicsList[index].longitude = paramedic.longitude;

  }
}