import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:roomify/services/get_actual_ubication.dart';

class MapPicker extends StatefulWidget {
  final LatLng? initialLocation;
  const MapPicker({Key? key, this.initialLocation}) : super(key: key);

  @override
  MapPickerScreenState createState() => MapPickerScreenState();
}

class MapPickerScreenState extends State<MapPicker> {
  LatLng? _pickedLocation;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    LatLng? userLocation = await getCurrentLocation();

    setState(() {
      _pickedLocation =
          userLocation ??
          widget.initialLocation ??
          LatLng(9.934739, -84.087502);
    });
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
      body: FlutterMap(
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
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
                      (_) =>
                          Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
