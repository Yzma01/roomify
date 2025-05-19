import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomify/components/actions/Button.dart';
import 'package:roomify/components/inputs/ComboBox.dart';
import 'package:roomify/components/inputs/Input.dart';
import 'package:roomify/components/inputs/MultiComboBox.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _monthlyPaymentController = TextEditingController();
  final _sizeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _depositController = TextEditingController();

  String? _deparmentType;
  String? _monthlyPaymentType = '';
  String? _petsAmount;

  late Future<List<String>> services;
  List<String> _clientServices = [];

  List<String> minMonthDuration = [];

  late Future<List<String>> petsAllowed;
  List<String> _clientPets = [];

  bool _pets = false;
  bool _deposit = false;
  bool _party = false;
  bool _smoking = false;
  bool _disablePeople = false;
  bool _isLoading = false;

  List<String> amount = ['1', '2', '3', '4', '5'];
  String? _minMonthDuration = '';

  @override
  void initState() {
    super.initState();
    services = getServices();
    petsAllowed = getPets();
    minMonthDuration = getMinMonthDuration();
  }

  Future<void> saveProperty() async {}

  List<String> getMinMonthDuration() {
    List<String> items = [];

    for (var i = 0; i < 12; i++) {
      if (i == 0) {
        items.add('1 Mes');
      } else {
        items.add('${i + 1} Meses');
      }
    }
    items.add('No es necesario');
    return items;
  }

  Future<List<String>> getServices() async {
    List<String> _services = [
      'Agua',
      'Luz',
      'Parqueo',
      'Zona Verde',
      'Cable',
      'Internet',
    ];
    return _services;
  }

  Future<List<String>> getPets() async {
    List<String> _services = [
      'Gato',
      'Hamster',
      'Perro Grande',
      'Perro Pequeño',
    ];
    return _services;
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
          return Center(child: Text('Error al cargar ${title}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay ${title} disponibles'));
        }
        return SingleChildScrollView(
          child: MultiComboBox(
            onConfirm: onConfirm,
            icon: Icons.arrow_drop_down,
            title: title,
            label: label,
            initialValues: itemsSelected,
            items: snapshot.data!,
          ),
        );
      },
    );
  }

  Widget checkBox({
    required String text,
    required onChanged,
    required bool value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Row(
        children: [
          Text(text, style: TextStyle(fontWeight: FontWeight.w500)),
          Checkbox(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget section({required String text}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget basicInformation() {
    return Column(
      spacing: 10,
      children: [
        section(text: 'Información Básica'),
        //House or department
        ComboBox(
          items: ['Departamento', 'Casa'],
          label: 'Tipo de edificio',
          onChanged:
              (value) => setState(() {
                _deparmentType = value;
              }),
          validator:
              (value) =>
                  value!.isEmpty ? 'Seleccione un tipo de edificio' : null,
        ),
        //Bedrooms
        ComboBox(
          items: ['1', '2', '3', '4', '5'],
          label: 'Cantidad de habitaciones',
          validator:
              (value) =>
                  value!.isEmpty
                      ? 'Seleccione la cantidad de habitaciones'
                      : null,
        ),
        //Bathrooms
        ComboBox(
          items: ['1', '2', '3', '4', '5'],
          label: 'Cantidad de Baños',
          validator:
              (value) =>
                  value!.isEmpty ? 'Seleccione la cantidad de baños' : null,
        ),

        // TODO IMAGES
        Text('Imagenes'),
        // TODO DIRECTION
        Text('Dirección'),
        //Size of the space
        Input(
          keyboardType: TextInputType.number,
          controller: _sizeController,
          label: 'Tamaño en m²',
          validator:
              (value) =>
                  value!.isEmpty
                      ? 'Ingrese en tamaño en m² de la vivienda'
                      : null,
        ),

        //Description
        Input(
          controller: _descriptionController,
          label: 'Descripción',
          validator:
              (value) =>
                  value!.isEmpty ? 'Ingrese el monto del alquiler' : null,
        ),
      ],
    );
  }

  Widget permitsAllow() {
    return Column(
      spacing: 10,
      children: [
        section(text: 'Permisos'),
        //Pets
        checkBox(
          text: 'Mascotas',

          onChanged:
              (value) => setState(() {
                _pets = value;
              }),
          value: _pets,
        ),
        if (_pets)
          futureMenu(
            items: petsAllowed,
            itemsSelected: _clientPets,
            title: 'Mascotas',
            label: 'Seleccione las mascotas',
            onConfirm:
                (values) => setState(() {
                  _clientPets = values;
                }),
          ),
        if (_pets)
          ComboBox(
            items: amount,
            label: 'Cantidad de Mascotas',
            onChanged:
                (value) => setState(() {
                  _petsAmount = value;
                }),
          ),
        //Party
        checkBox(
          text: 'Fiestas',
          onChanged:
              (value) => setState(() {
                _party = value;
              }),
          value: _party,
        ),
        //Smoke
        checkBox(
          text: 'Fumar',
          onChanged:
              (value) => setState(() {
                _smoking = value;
              }),
          value: _smoking,
        ),
      ],
    );
  }

  Widget servicesProvide() {
    return Column(
      spacing: 10,
      children: [
        section(text: 'Servicios'),
        //Services
        futureMenu(
          items: services,
          itemsSelected: _clientServices,
          title: 'Servicios',
          label: 'Seleccione los Servicios',
          onConfirm:
              (values) => setState(() {
                _clientServices = values;
              }),
        ),
      ],
    );
  }

  Widget financialConditions() {
    return Column(
      spacing: 10,
      children: [
        section(text: 'Condiciones Financieras'),
        //Deposit Required
        checkBox(
          text: 'Deposito de Garantía',
          onChanged:
              (value) => setState(() {
                _deposit = value;
              }),
          value: _deposit,
        ),
        if (_deposit)
          Input(
            keyboardType: TextInputType.number,
            controller: _depositController,
            label: 'Mónto del Depósito',
            validator:
                (value) =>
                    value!.isEmpty ? 'Ingrese el monto del depósito' : null,
          ),
        //Monthly Payment Type
        ComboBox(
          items: ['Mensual', 'Quincenal', 'Semanal'],
          label: 'Frecuencia de pago',
          onChanged:
              (value) => setState(() {
                _monthlyPaymentType = value;
              }),
        ),

        //Monthly payment
        Input(
          controller: _monthlyPaymentController,
          label: 'Monto',
          keyboardType: TextInputType.number,
          validator:
              (value) =>
                  value!.isEmpty ? 'Ingrese el monto del alquiler' : null,
        ),
      ],
    );
  }

  Widget rentalConditions() {
    return Column(
      spacing: 10,
      children: [
        section(text: 'Condiciones de Alquiler'),
        //Min Duration
        ComboBox(
          items: minMonthDuration,
          label: 'Duración Minima de Alquiler',
          onChanged:
              (value) => setState(() {
                _minMonthDuration = value;
              }),
        ),
        //Disable Persons
        checkBox(
          text: 'Personas Discapacitadas',
          onChanged:
              (value) => setState(() {
                _disablePeople = value;
              }),
          value: _disablePeople,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                //Title
                Text(
                  'Registro de Vivienda',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                ),

                //Basic Information
                basicInformation(),

                //Financial Conditions
                financialConditions(),

                //Rental Contitions
                rentalConditions(),

                //Allow
                permitsAllow(),

                //Services Proovide
                servicesProvide(),

                SizedBox(height: 20, width: double.infinity,),

                Button(
                  isLoading: _isLoading,
                  onPressed: saveProperty,
                  label: 'Guardar',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
