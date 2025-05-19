import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
      child: DropdownButtonFormField2<String>(
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
        isExpanded: true,
        value: _role,
        items:
            widget.items
                .map(
                  (item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)),
                )
                .toList(),
        onChanged: (value) {
          setState(() {
            _role = value;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        validator:
            widget.validator ??
            (value) => value == null ? 'Por favor selecciona una opción' : null,
      ),
    );
  }
}
