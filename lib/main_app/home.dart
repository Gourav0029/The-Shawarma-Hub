import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_shawarma_hub/helper/location_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraPosition? _kGooglePlex;
  late GoogleMapController mapController;
  final locationHelper = LocationHelper();

  @override
  void initState() {
    super.initState();
    locationHelper.initLocation();
  }

  Set<Marker> marker = <Marker>{
    const Marker(
      markerId: MarkerId('id'),
      position: LatLng(22.8081195, 86.1987083),
      infoWindow: InfoWindow(
        title: 'The Shawarma Hub',
        snippet: 'Near Jubliee Park',
      ),
    )
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.zero,
              height: screenHeight * 0.5,
              child: GoogleMap(
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
                initialCameraPosition: _kGooglePlex ??
                    CameraPosition(
                      target: LatLng(locationHelper.currentLocation.latitude,
                          locationHelper.currentLocation.longitude),
                      zoom: 14.0,
                    ),
                markers: marker,
                onMapCreated: (controller) {
                  mapController = controller;
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
            //const SizedBox(height: ),
            SizedBox(
              width: screenWidth,
              //height: screenHeight * 0.5,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F4F2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: rectangularcontent(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget rectangularcontent(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'About Us:',
            style: GoogleFonts.outfit(
                fontSize: 18,
                color: const Color(0xFF201135),
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Welcome to The Shawarma Hub, where authenticity meets flavor in every bite! 🌯\n\n'
            'At The Shawarma Hub, we are passionate about crafting the perfect shawarma, using only the freshest ingredients and time-honored recipes. Our journey began with a simple love for this delicious Middle Eastern dish, and today, we take pride in serving our community with flavors that are both traditional and innovative.\n\n'
            'Every shawarma we make tells a story—of spices, of heritage, and of the joy that comes from sharing a meal with loved ones. Whether you\'re a longtime shawarma enthusiast or a curious first-timer, we promise an unforgettable culinary experience.\n\n'
            'Come join us at The Shawarma Hub, and let\'s savor the taste of tradition, together. 🍽️',
            style: GoogleFonts.outfit(
                fontSize: 16,
                color: const Color(0xFF201135),
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
