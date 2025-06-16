import 'package:flutter/material.dart';
import 'package:roomify/services/firebase_services.dart';

class Filter extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final Function(Map<String, dynamic>) onApply;
  final List<String> availableServices;

  const Filter({
    Key? key,
    required this.onApply,
    required this.initialFilters,
    required this.availableServices,
  }) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  // Estado del filtro
  bool pets = false;
  bool parties = false;
  bool smoking = false;
  bool accessible = false;
  String rooms = '0';
  String? minRentalDuration;
  String? departmentType;
  List<String> services = [];

  final List<String> _rentalDurationOptions = List.generate(
    12,
    (index) => '${index + 1} Mes${index == 0 ? '' : 'es'}',
  )..add('No es necesario');

  final List<String> _propertyTypes = ['Departamento', 'Casa'];

  late List<String> _availableServices;

  @override
  void initState() {
    super.initState();
    _availableServices = widget.availableServices;
    services = [];
    pets = widget.initialFilters['pets'] ?? false;
    parties = widget.initialFilters['parties'] ?? false;
    smoking = widget.initialFilters['smoking'] ?? false;
    accessible = widget.initialFilters['accessible'] ?? false;
    rooms = widget.initialFilters['bedrooms'] ?? '0';
    minRentalDuration = widget.initialFilters['minRentalDuration'];
    departmentType = widget.initialFilters['departmentType'];
    services = List<String>.from(widget.initialFilters['services'] ?? []);
  }

  void setRooms(value) {
    setState(() {
      rooms = value;
    });
  }

  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onApply({
              'bedrooms': '0',
              'pets': false,
              'parties': false,
              'smoking': false,
              'accessible': false,
              'departmentType': null,
              'minRentalDuration': null,
              'services': [],
            });
          },

          icon: Icon(Icons.delete_outline),
          tooltip: 'Limpiar filtros',
        ),
        Text("Filtros"),

        IconButton(
          onPressed: () {
            final filters = {
              'bedrooms': rooms,
              'pets': pets,
              'parties': parties,
              'smoking': smoking,
              'accessible': accessible,
              'departmentType': departmentType,
              'minRentalDuration': minRentalDuration,
              'services': services,
            };

            widget.onApply(filters);
            Navigator.pop(context); // Cierra el modal
          },
          icon: Icon(Icons.check),
        ),
      ],
    );
  }

  Widget _title(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(title, style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _roomText(text) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: rooms == text ? Colors.blue : Colors.transparent,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: rooms == text ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _amountOfRooms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title('Cantidad de habitaciones: $rooms'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              ['1', '2', '3', '4', '5'].map((num) {
                return ElevatedButton(
                  onPressed: () => setRooms(num),
                  child: _roomText(num),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _allow(String title, bool value, void Function(bool?) onChanged) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        Checkbox(activeColor: Colors.blue, value: value, onChanged: onChanged),
      ],
    );
  }

  Widget _comboBox<T>({
    required List<T> items,
    required String? value,
    required String label,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(label),
        DropdownButton<T>(
          isExpanded: true,
          value: value as T?,
          hint: Text('Seleccione'),
          items:
              items.map((e) {
                return DropdownMenuItem<T>(value: e, child: Text(e.toString()));
              }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _servicesSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title("Servicios incluidos"),
        Wrap(
          spacing: 8.0,
          children:
              _availableServices.map((service) {
                final selected = services.contains(service);
                return FilterChip(
                  selected: selected,
                  label: Text(service),
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        services.add(service);
                      } else {
                        services.remove(service);
                      }
                    });
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      _amountOfRooms(),
                      _comboBox<String>(
                        items: _propertyTypes,
                        value: departmentType,
                        label: 'Tipo de propiedad',
                        onChanged: (value) {
                          setState(() {
                            departmentType = value!;
                          });
                        },
                      ),
                      _comboBox<String>(
                        items: _rentalDurationOptions,
                        value: minRentalDuration,
                        label: 'Duración mínima de alquiler',
                        onChanged: (value) {
                          setState(() {
                            minRentalDuration = value!;
                          });
                        },
                      ),
                      _servicesSelect(),

                      _title('Permisos'),
                      _allow(
                        "Mascotas",
                        pets,
                        (val) => setState(() => pets = val!),
                      ),
                      _allow(
                        "Fiestas",
                        parties,
                        (val) => setState(() => parties = val!),
                      ),
                      _allow(
                        "Fumar",
                        smoking,
                        (val) => setState(() => smoking = val!),
                      ),
                      _allow(
                        "Accesibilidad",
                        accessible,
                        (val) => setState(() => accessible = val!),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
