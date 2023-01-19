import 'package:delicious_vendor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapLocationPicker(
        apiKey: mapsApiKey,
        onNext: (GeocodingResult? result) {
          if(result!= null) {
            Navigator.pop(context, {
              "marketLocation": result.formattedAddress,
              'latitude': result.geometry.location.lat,
              'longitude': result.geometry.location.lng,
            });
          }
        },
      ),
    );
  }
}
