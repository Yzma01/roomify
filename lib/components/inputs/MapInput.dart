import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:roomify/screens/map/MapPicker.dart';
import 'dart:async';
import 'package:roomify/services/get_actual_ubication.dart';

class MapInput extends StatefulWidget {
  final String label;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final IconData icon;
  final Color iconColor;
  final bool userCurrentLocation;
  final void Function(LatLng?)? onChanged;
  final String? Function(String?)? validator;

  const MapInput({
    Key? key,
    this.label = 'Selecciona ubicación',
    this.padding = const EdgeInsets.only(bottom: 16.0),
    this.decoration,
    this.initialLocation,
    required this.onChanged,
    this.icon = Icons.location_on,
    this.iconColor = Colors.black,
    this.validator,
    this.userCurrentLocation = false,
  }) : super(key: key);

  final LatLng? initialLocation;

  @override
  _MapInputState createState() => _MapInputState();
}

class _MapInputState extends State<MapInput> {
  LatLng? _selectedLocation;
  final TextEditingController _controller = TextEditingController();

  Future<void> _openMapPicker() async {
    final picked = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) => MapPicker(initialLocation: _selectedLocation),
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedLocation = picked;
        _controller.text =
            'Lat: ${picked.latitude.toStringAsFixed(6)}, Lng: ${picked.longitude.toStringAsFixed(6)}';
      });
      if (widget.onChanged != null) widget.onChanged!(picked);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.userCurrentLocation) {
      getCurrentLocation().then((loc) {
        if (loc != null) {
          setState(() {
            _selectedLocation = loc;
            _controller.text =
                'Lat: ${loc.latitude.toStringAsFixed(6)}, Lng: ${loc.longitude.toStringAsFixed(6)}';
            if (widget.onChanged != null) widget.onChanged!(loc);
          });
        }
      });
    } else if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _controller.text =
          'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(6)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding!,
      child: GestureDetector(
        onTap: _openMapPicker,
        child: AbsorbPointer(
          child: Container(
            decoration:
                widget.decoration ??
                BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
            child: TextFormField(
              controller: _controller,
              validator: widget.validator,
              decoration: InputDecoration(
                labelText: widget.label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                prefixIcon: Icon(
                  widget.icon ?? widget.icon,
                  color: widget.iconColor ?? widget.iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}