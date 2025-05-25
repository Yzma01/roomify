import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagesPicker extends FormField<List<XFile>> {
  ImagesPicker({
    Key? key,
    FormFieldSetter<List<XFile>>? onSaved,
    FormFieldValidator<List<XFile>>? validator,
    List<XFile>? initialValue,
    bool autovalidate = false,
    this.onChanged,
    this.padding = const EdgeInsets.only(bottom: 16.0),
    this.decoration,
    this.icon = Icons.photo_library,
    this.iconColor = Colors.black,
    this.label = 'Seleccionar Imágenes',
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue ?? [],
          autovalidateMode:
              autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
          builder: (FormFieldState<List<XFile>> state) {
            return _ImagesPickerField(
              state: state,
              padding: padding,
              decoration: decoration,
              icon: icon,
              iconColor: iconColor,
              label: label,
              onChanged: onChanged,
            );
          },
        );

  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final IconData icon;
  final Color iconColor;
  final String label;
  final ValueChanged<List<XFile>>? onChanged;
}

class _ImagesPickerField extends StatefulWidget {
  final FormFieldState<List<XFile>> state;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final IconData icon;
  final Color iconColor;
  final String label;
  final ValueChanged<List<XFile>>? onChanged;

  const _ImagesPickerField({
    Key? key,
    required this.state,
    this.padding,
    this.decoration,
    required this.icon,
    required this.iconColor,
    required this.label,
    this.onChanged,
  }) : super(key: key);

  @override
  State<_ImagesPickerField> createState() => _ImagesPickerFieldState();
}

class _ImagesPickerFieldState extends State<_ImagesPickerField> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile>? selected = await _picker.pickMultiImage(
      imageQuality: 85,
    );
    if (selected != null && selected.isNotEmpty) {
      widget.state.didChange(selected);
      if (widget.onChanged != null){
        widget.onChanged!(selected);
      }
      widget.state.validate();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.state.value ?? [];

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: widget.decoration ??
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
                color: widget.iconColor,
              ),
              label: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
          images.isNotEmpty
              ? Center(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: images
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
          if (widget.state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16),
              child: Text(
                widget.state.errorText ?? '',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
