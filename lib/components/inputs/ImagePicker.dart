import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagesPicker extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final IconData icon;
  final Color iconColor;
  final String label;
  final void Function(List<XFile>) onImagesSelected;

  const ImagesPicker({
    Key? key,
    required this.onImagesSelected,
    this.padding = const EdgeInsets.only(bottom: 16.0),
    this.decoration,
    this.label = 'Seleccionar Imágenes',
    this.icon = Icons.photo_library,
    this.iconColor = Colors.black,
  }) : super(key: key);

  @override
  State<ImagesPicker> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagesPicker> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  Future<void> _pickImages() async {
    final List<XFile>? selected = await _picker.pickMultiImage(
      imageQuality: 85,
    );
    if (selected != null && selected.isNotEmpty) {
      setState(() {
        _images = selected;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Botón que se ve como el input
          Container(
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
            child: TextButton.icon(
              onPressed: _pickImages,
              icon: Icon(
                widget.icon,
                color: widget.iconColor ?? widget.iconColor,
              ),
              label: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: const Color.fromARGB(190, 0, 0, 0),
                    letterSpacing: 0.20,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _images != null && _images!.isNotEmpty
              ? Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      _images!
                          .map(
                            (img) => ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(img.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          .toList(),
                ),
              )
              : Text(
                'Ninguna imagen seleccionada',
                style: TextStyle(color: Colors.grey[600]),
              ),
        ],
      ),
    );
  }
}
