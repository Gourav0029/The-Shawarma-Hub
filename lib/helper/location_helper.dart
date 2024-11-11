import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHelper {
  String currentAddress = 'My Address';
  String currentCity = 'My City';
  String currentState = 'State';
  Position? currentposition;
  LatLng currentLocation = const LatLng(22.8081195, 86.1987083);

  Future<void> initLocation() async {
    // Use geolocator to get the current location
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      // _showErrorSnackBar('Location service is disabled.');
      return Future.error('Location service is disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // _showErrorSnackBar('Location Permission denied.');
        return Future.error('Location Permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      //_showErrorSnackBar('Location Permission is denied forever.');
      return Future.error('Location Permission is denied forever.');
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      currentLocation = LatLng(position.latitude, position.longitude);

      currentposition = position;
      currentAddress =
          "${place.locality} ${place.postalCode}, ${place.country}";
      currentCity = "${place.locality}";
      currentState = '${place.administrativeArea}';

      log(currentAddress);
    } catch (e) {
      debugPrint(e as String?);
      return Future.error('Error getting location. Please try again later.');
    }
  }
}
