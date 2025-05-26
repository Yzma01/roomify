import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:roomify/services/get_actual_ubication.dart';
import 'package:flutter_map/plugin_api.dart';

class MapPicker extends StatefulWidget {
  final LatLng? initialLocation;
  const MapPicker({Key? key, this.initialLocation}) : super(key: key);

  @override
  MapPickerScreenState createState() => MapPickerScreenState();
}

class MapPickerScreenState extends State<MapPicker> {
  LatLng? _pickedLocation;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    if (widget.initialLocation != null) {
      setState(() {
        _pickedLocation = widget.initialLocation;
      });
    } else {
      LatLng? userLocation = await getCurrentLocation();

      setState(() {
        _pickedLocation = userLocation ?? LatLng(9.934739, -84.087502);
      });
    }
  }

  Future<void> _goToCurrentLocation() async {
    final currentLocation = await getCurrentLocation();
    if (currentLocation != null) {
      setState(() {
        _pickedLocation = currentLocation;
      });
      _mapController.move(currentLocation, _mapController.zoom);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se encontró la ubicación actual.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pickedLocation == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Selecciona Ubicación')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona ubicación'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _pickedLocation);
            },
            child: Text('OK', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _pickedLocation,
              zoom: 13.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _pickedLocation = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.tuapp.tuapp',
              ),
              if (_pickedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _pickedLocation!,
                      width: 40,
                      height: 40,
                      builder:
                          (_) => Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              backgroundColor: Colors.white,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
