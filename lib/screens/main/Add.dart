import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:roomify/components/actions/Button.dart';
import 'package:roomify/components/inputs/CheckBox.dart';
import 'package:roomify/components/inputs/ComboBox.dart';
import 'package:roomify/components/inputs/ImagePicker.dart';
import 'package:roomify/components/inputs/Input.dart';
import 'package:roomify/components/inputs/MapInput.dart';
import 'package:roomify/components/inputs/MultiComboBox.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para inputs de texto
  final _monthlyPaymentController = TextEditingController();
  final _sizeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _depositController = TextEditingController();

  // Variables para guardar datos
  String? _departmentType;
  String? _monthlyPaymentType;
  String? _petsAmount;
  LatLng? _location;

  List<String> _servicesSelected = [];
  List<String> _petsAllowedSelected = [];
  String? _minMonthDuration;

  List<XFile> _images = [];

  bool _pets = false;
  bool _deposit = false;
  bool _party = false;
  bool _smoking = false;
  bool _disablePeople = false;

  // Opcionales - si quieres puedes guardar aquí el valor de habitaciones y baños (si usas ComboBox para eso)
  String? _bedroomsAmount;
  String? _bathroomsAmount;

  List<String> _amountOptions = ['1', '2', '3', '4', '5'];
  List<String> _minMonthDurationOptions = [];

  late Future<List<String>> _servicesFuture;
  late Future<List<String>> _petsFuture;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _servicesFuture = getServices();
    _petsFuture = getPets();
    _minMonthDurationOptions = _generateMinMonthDuration();
  }

  List<String> _generateMinMonthDuration() {
    List<String> items = [];
    for (var i = 0; i < 12; i++) {
      items.add('${i + 1} Mes${i == 0 ? '' : 'es'}');
    }
    items.add('No es necesario');
    return items;
  }

  Future<List<String>> getServices() async {
    return [
      'Agua',
      'Luz',
      'Parqueo',
      'Zona Verde',
      'Cable',
      'Internet',
    ];
  }

  Future<List<String>> getPets() async {
    return [
      'Gato',
      'Hamster',
      'Perro Grande',
      'Perro Pequeño',
    ];
  }

  Future<void> saveProperty() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Aquí el código para guardar los datos, por ejemplo en Firebase
        // Datos que usarás:
        print('Tipo de departamento: $_departmentType');
        print('Habitaciones: $_bedroomsAmount');
        print('Baños: $_bathroomsAmount');
        print('Imágenes seleccionadas: ${_images.length}');
        print('Ubicación: ${_location?.latitude}, ${_location?.longitude}');
        print('Tamaño: ${_sizeController.text}');
        print('Descripción: ${_descriptionController.text}');
        print('Depósito: $_deposit');
        if (_deposit) print('Monto depósito: ${_depositController.text}');
        print('Pago mensual: ${_monthlyPaymentController.text}');
        print('Tipo pago mensual: $_monthlyPaymentType');
        print('Mascotas permitidas: $_pets');
        if (_pets) {
          print('Tipos mascotas: $_petsAllowedSelected');
          print('Cantidad mascotas: $_petsAmount');
        }
        print('Fiestas permitidas: $_party');
        print('Fumar permitido: $_smoking');
        print('Personas discapacitadas: $_disablePeople');
        print('Servicios: $_servicesSelected');
        print('Duración mínima alquiler: $_minMonthDuration');

        // Simula guardado:
        await Future.delayed(Duration(seconds: 2));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Propiedad guardada correctamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la propiedad: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget futureMenu({
    required Future<List<String>> items,
    required List<String> itemsSelected,
    required String title,
    required String label,
    required Function(List<String>) onConfirm,
  }) {
    return FutureBuilder<List<String>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar $title'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay $title disponibles'));
        }
        return MultiComboBox(
          onConfirm: onConfirm,
          icon: Icons.arrow_drop_down,
          title: title,
          label: label,
          initialValues: itemsSelected,
          items: snapshot.data!,
        );
      },
    );
  }

  Widget section({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget basicInformation() {
    return Column(
      spacing: 10,
      children: [
        section(text: 'Información Básica'),
        ComboBox(
          items: ['Departamento', 'Casa'],
          label: 'Tipo de edificio',
          icon: Icons.house,
          iconColor: Colors.blueAccent,
          onChanged: (value) {
            setState(() {
              _departmentType = value;
            });
          },
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Seleccione un tipo de edificio' : null,
        ),
        ComboBox(
          items: _amountOptions,
          label: 'Cantidad de habitaciones',
          icon: Icons.hotel,
          iconColor: Colors.blueAccent,
          onChanged: (value) {
            setState(() {
              _bedroomsAmount = value;
            });
          },
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Seleccione cantidad de habitaciones' : null,
        ),
        ComboBox(
          items: _amountOptions,
          label: 'Cantidad de baños',
          icon: Icons.bathtub,
          iconColor: Colors.blueAccent,
          onChanged: (value) {
            setState(() {
              _bathroomsAmount = value;
            });
          },
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Seleccione cantidad de baños' : null,
        ),
        ImagesPicker(
          iconColor: Colors.blueAccent,
          onSaved: (imagesSelected) {
            setState(() {
              _images = imagesSelected ?? [];
            });
          },
          validator: (imagesSelected) {
            if (imagesSelected == null || imagesSelected.isEmpty) {
              return 'Debes seleccionar al menos una imagen';
            }
            return null;
          },
        ),
        MapInput(
          label: 'Ubicación',
          onChanged: (locationSelected) {
            setState(() {
              _location = locationSelected;
            });
          },
          validator: (val) =>
              (val == null || val.isEmpty) ? 'Por favor seleccione una ubicación' : null,
          iconColor: Colors.blueAccent,
          userCurrentLocation: true,
        ),
        Input(
          keyboardType: TextInputType.number,
          controller: _sizeController,
          label: 'Tamaño en m²',
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Ingrese el tamaño en m² de la vivienda' : null,
        ),
        Input(
          controller: _descriptionController,
          label: 'Descripción',
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Ingrese la descripción' : null,
        ),
      ],
    );
  }

  Widget permitsAllow() {
    return Column(
      spacing: 10,
      children: [
        section(text: 'Permisos'),
        CustomCheckbox(
          text: 'Mascotas',
          value: _pets,
          onChanged: (bool? newValue) {
            setState(() {
              _pets = newValue ?? false;
              if (!_pets) {
                _petsAllowedSelected.clear();
                _petsAmount = null;
              }
            });
          },
        ),
        if (_pets)
          futureMenu(
            items: _petsFuture,
            itemsSelected: _petsAllowedSelected,
            title: 'Mascotas',
            label: 'Tipos de mascotas permitidas',
            onConfirm: (selected) {
              setState(() {
                _petsAllowedSelected = selected;
              });
            },
          ),
        if (_pets)
          ComboBox(
            items: _amountOptions,
            label: 'Cantidad de mascotas',
            icon: Icons.pets,
            iconColor: Colors.blueAccent,
            onChanged: (value) {
              setState(() {
                _petsAmount = value;
              });
            },
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Seleccione cantidad de mascotas' : null,
          ),
        CustomCheckbox(
          text: 'Fiestas',
          value: _party,
          onChanged: (bool? newValue) {
            setState(() {
              _party = newValue ?? false;
            });
          },
        ),
        CustomCheckbox(
          text: 'Fumar',
          value: _smoking,
          onChanged: (bool? newValue) {
            setState(() {
              _smoking = newValue ?? false;
            });
          },
        ),
        CustomCheckbox(
          text: 'Personas con discapacidad',
          value: _disablePeople,
          onChanged: (bool? newValue) {
            setState(() {
              _disablePeople = newValue ?? false;
            });
          },
        ),
      ],
    );
  }

  Widget servicesProvide() {
    return Column(
      spacing: 10,
      children: [
        section(text: 'Servicios que ofrece'),
        futureMenu(
          items: _servicesFuture,
          itemsSelected: _servicesSelected,
          title: 'Servicios',
          label: 'Seleccione servicios que ofrece',
          onConfirm: (selected) {
            setState(() {
              _servicesSelected = selected;
            });
          },
        ),
      ],
    );
  }

  Widget financialConditions() {
    return Column(
      spacing: 10,
      children: [
        section(text: 'Condiciones financieras'),
        CustomCheckbox(
          text: 'Depósito',
          value: _deposit,
          onChanged: (bool? newValue) {
            setState(() {
              _deposit = newValue ?? false;
              if (!_deposit) {
                _depositController.clear();
              }
            });
          },
        ),
        if (_deposit)
          Input(
            keyboardType: TextInputType.number,
            controller: _depositController,
            label: 'Monto de depósito',
            validator: (value) {
              if (_deposit && (value == null || value.isEmpty)) {
                return 'Ingrese el monto de depósito';
              }
              return null;
            },
          ),
        Input(
          keyboardType: TextInputType.number,
          controller: _monthlyPaymentController,
          label: 'Pago mensual',
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Ingrese el pago mensual' : null,
        ),
        ComboBox(
          items: ['Al mes', 'Al día', 'Al año'],
          label: 'Tipo de pago mensual',
          icon: Icons.payment,
          iconColor: Colors.blueAccent,
          onChanged: (value) {
            setState(() {
              _monthlyPaymentType = value;
            });
          },
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Seleccione tipo de pago mensual' : null,
        ),
      ],
    );
  }

  Widget rentalConditions() {
    return Column(
      spacing: 10,
      children: [
        section(text: 'Condiciones de alquiler'),
        ComboBox(
          items: _minMonthDurationOptions,
          label: 'Duración mínima de alquiler',
          icon: Icons.calendar_today,
          iconColor: Colors.blueAccent,
          onChanged: (value) {
            setState(() {
              _minMonthDuration = value;
            });
          },
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Seleccione duración mínima' : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Propiedad'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 10,
            children: [
              basicInformation(),
              
              permitsAllow(),
              
              servicesProvide(),
              
              financialConditions(),
              
              rentalConditions(),
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Button(
                    isLoading: _isLoading,   
                    label: 'Guardar',                 onPressed: saveProperty
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
