import 'package:flutter/material.dart';

class ComboBox extends StatefulWidget {
  final String? label;
  final List<String> items;
  final String? initialValue;
  final IconData? icon;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const ComboBox({
    Key? key,
    required this.items,
    this.label,
    this.initialValue,
    this.icon,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  _ComboBoxState createState() => _ComboBoxState();
}

class _ComboBoxState extends State<ComboBox> {
  String? _role;

  @override
  void initState() {
    super.initState();
    _role = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Requiere fondo para ver la sombra
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3), // sombra hacia abajo
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: widget.label ?? 'Seleccionar',
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
          prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        ),
        value: _role,
        items: widget.items
            .map(
              (option) => DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              ),
            )
            .toList(),
        dropdownColor: Colors.white,
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            _role = value;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        validator: widget.validator ??
            (value) => value == null ? 'Por favor selecciona una opción' : null,
      ),
    );
  }
}
