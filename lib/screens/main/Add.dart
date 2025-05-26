import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:roomify/components/actions/Button.dart';
import 'package:roomify/components/hooks/UserProvider.dart';
import 'package:roomify/components/inputs/CheckBox.dart';
import 'package:roomify/components/inputs/ComboBox.dart';
import 'package:roomify/components/inputs/FutureMenu.dart';
import 'package:roomify/components/inputs/ImagePicker.dart';
import 'package:roomify/components/inputs/Input.dart';
import 'package:roomify/components/inputs/MapInput.dart';
import 'package:roomify/models/Property.dart';
import 'package:roomify/services/firebase_services.dart';
import 'package:roomify/components/outputs/Section.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _monthlyPaymentController = TextEditingController();
  final _sizeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _depositController = TextEditingController();

  String _departmentType = '';
  String _monthlyPaymentType = '';
  String? _petsAmount;
  LatLng? _location;

  List<String> _servicesSelected = [];
  List<String> _petsAllowedSelected = [];
  String _minMonthDuration = '';

  List<XFile> _images = [];

  bool _pets = false;
  bool _deposit = false;
  bool _party = false;
  bool _smoking = false;
  bool _disablePeople = false;

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

  Future<void> saveData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final property = Property(
          departmentType: _departmentType,
          bedroomsAmount: int.parse(_bedroomsAmount!),
          bathroomsAmount: int.parse(_bathroomsAmount!),
          images: _images,
          location: _location,
          size: _sizeController.text,
          description: _descriptionController.text,
          deposit: _deposit,
          depositAmount: _deposit ? _depositController.text : null,
          monthlyPaymentAmount: _monthlyPaymentController.text,
          monthlyPaymentType: _monthlyPaymentType,
          petsAllowed: _pets,
          petsAllowedSelected: _pets ? _petsAllowedSelected : null,
          petsAmount: _pets ? int.parse(_petsAmount!) : null,
          partyAllowed: _party,
          smokingAllowed: _smoking,
          disablePeopleAllowed: _disablePeople,
          servicesSelected: _servicesSelected,
          minMonthDuration: _minMonthDuration,
        );
        final user = Provider.of<UserProvider>(context, listen: false).user;
        if (user == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('No hay usuario registrado')));
          return;
        }
        await saveProperty(property, user);

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

  Widget basicInformation() {
    return Column(
      spacing: 10,
      children: [
        Section(text: 'Información Básica'),
        ComboBox(
          items: ['Departamento', 'Casa'],
          label: 'Tipo de edificio',
          icon: Icons.house,
          iconColor: Colors.blueAccent,
          onChanged: (value) {
            setState(() {
              _departmentType = value!;
            });
          },
          validator:
              (value) =>
                  (value == null || value.isEmpty)
                      ? 'Seleccione un tipo de edificio'
                      : null,
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
          validator:
              (value) =>
                  (value == null || value.isEmpty)
                      ? 'Seleccione cantidad de habitaciones'
                      : null,
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
          validator:
              (value) =>
                  (value == null || value.isEmpty)
                      ? 'Seleccione cantidad de baños'
                      : null,
        ),
        ImagesPicker(
          iconColor: Colors.blueAccent,
          onChanged: (imagesSelected) {
            print('images: ${imagesSelected!.length}');
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
          validator:
              (val) =>
                  (val == null || val.isEmpty)
                      ? 'Por favor seleccione una ubicación'
                      : null,
          iconColor: Colors.blueAccent,
          userCurrentLocation: true,
        ),
        Input(
          keyboardType: TextInputType.number,
          controller: _sizeController,
          label: 'Tamaño en m²',
          validator:
              (value) =>
                  (value == null || value.isEmpty)
                      ? 'Ingrese el tamaño en m² de la vivienda'
                      : null,
        ),
        Input(
          controller: _descriptionController,
          label: 'Descripción',
          validator:
              (value) =>
                  (value == null || value.isEmpty)
                      ? 'Ingrese la descripción'
                      : null,
        ),
      ],
    );
  }

  Widget permitsAllow() {
    return Column(
      spacing: 10,
      children: [
        Section(text: 'Permisos'),
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
          FutureMenu(
            items: getPets(),
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
            validator:
                (value) =>
                    (value == null || value.isEmpty)
                        ? 'Seleccione cantidad de mascotas'
                        : null,
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
        Section(text: 'Servicios que ofrece'),
        FutureMenu(
          items: getServices(),
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
        Section(text: 'Condiciones financieras'),
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
          validator:
              (value) =>
                  (value == null || value.isEmpty)
                      ? 'Ingrese el pago mensual'
                      : null,
        ),
        ComboBox(
          items: ['Mensual', 'Quincenal', 'Diario'],
          label: 'Tipo de pago mensual',
          icon: Icons.payment,
          iconColor: Colors.blueAccent,
          onChanged: (value) {
            setState(() {
              _monthlyPaymentType = value!;
            });
          },
          validator:
              (value) =>
                  (value == null || value.isEmpty)
                      ? 'Seleccione tipo de pago mensual'
                      : null,
        ),
      ],
    );
  }

  Widget rentalConditions() {
    return Column(
      spacing: 10,
      children: [
        Section(text: 'Condiciones de alquiler'),
        ComboBox(
          items: _minMonthDurationOptions,
          label: 'Duración mínima de alquiler',
          icon: Icons.calendar_today,
          iconColor: Colors.blueAccent,
          onChanged: (value) {
            setState(() {
              _minMonthDuration = value!;
            });
          },
          validator:
              (value) =>
                  (value == null || value.isEmpty)
                      ? 'Seleccione duración mínima'
                      : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Propiedad')),
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
                    label: 'Guardar',
                    onPressed: saveData,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
