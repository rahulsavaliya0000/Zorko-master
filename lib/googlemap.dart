import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as locationService; // Renaming the prefix

class MapScreen extends StatefulWidget {
  final String city;

  const MapScreen({
    Key? key,
    required this.city, // Accept city as a parameter
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  locationService.LocationData? _currentLocation; // Renaming the prefix
  String _temperature = 'Loading...';
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  late String City; // Declare City variable
  String _apiKey = '8d6454a89dff871786a0307b0dbebbee';
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  Set<Marker> markers = Set();
  final List<LatLng> coordinates = [
    LatLng(21.2211127, 72.7771458), // Zorko Brand Of Food Lovers
    LatLng(21.1505555, 72.831373), // Zorko Pandesara
    LatLng(21.166096, 72.837839), // ZORKO, Brand Of Food Lovers
    LatLng(21.1618574, 72.8209844), // ZORKO Private limited
    LatLng(21.1862198, 72.8103599), // Zorko - Athwagate
    LatLng(21.1873286, 72.7787588), // Zorko, Brand of Food Lovers
    LatLng(21.16195, 72.8206729), // ZORKO Private limited
    LatLng(21.1672615, 72.8116913), // Zorko brand of food lovers
    LatLng(21.1435839, 72.7854542), // Zorko Brand Of Food Lovers
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    City = widget.city;
    _getWeatherData();
    _buildMarkers();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
    locationService.Location location =
    locationService.Location();
    try {
      _currentLocation = await location.getLocation();
      setState(() {});
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      print('Error getting current location: $e');
    }
  }

  Future<void> _getWeatherData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$City&units=metric&appid=$_apiKey'));

      if (response.statusCode == 200) {
        setState(() {
          _weatherData = json.decode(response.body);
        });
        _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
            _weatherData!['coord']['lat'], _weatherData!['coord']['lon'])));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

  }


  Future<Set<Marker>> _buildMarkers() async {

    final Uint8List markerIcon = await getBytesFromAsset("assets/img/zorko_loc.png".toString(), 80);
    // Add markers to the set
    for (int i = 0; i < coordinates.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('marker$i'),
          position: coordinates[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(title: 'Zorko Brand Of Food Lovers'), // Use a fixed title
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Stack(
        children: [
          if (_currentLocation != null)
            GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),


                zoom: 12,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(markers), // Call the method to build markers
            ),
          if (_currentLocation == null)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (_isSearching)
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search City',
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchController.clear();
                        });
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    _isSearching = false;

                    City = value;
                    _searchController.clear();

                    print(City);
                    _getWeatherData();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
