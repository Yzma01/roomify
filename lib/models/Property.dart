import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:latlong2/latlong.dart';
import 'package:roomify/components/outputs/Section.dart';

class Property {
  final String? uid;
  final String departmentType;
  final int bedroomsAmount;
  final int bathroomsAmount;
  final List<XFile> images;
  final List<String>? imagesUrls;
  final LatLng? location;
  final String size;
  final String description;
  final bool deposit;
  final String? depositAmount;
  final String monthlyPaymentAmount;
  final String monthlyPaymentType;
  final bool petsAllowed;
  final List<String>? petsAllowedSelected;
  final int? petsAmount;
  final bool partyAllowed;
  final bool smokingAllowed;
  final bool disablePeopleAllowed;
  final List<String> servicesSelected;
  final String minMonthDuration;

  Property({
    this.uid,
    required this.departmentType,
    required this.bedroomsAmount,
    required this.bathroomsAmount,
    required this.images,
    this.imagesUrls,
    required this.location,
    required this.size,
    required this.description,
    required this.deposit,
    this.depositAmount,
    required this.monthlyPaymentAmount,
    required this.monthlyPaymentType,
    required this.petsAllowed,
    this.petsAllowedSelected,
    this.petsAmount,
    required this.partyAllowed,
    required this.smokingAllowed,
    required this.disablePeopleAllowed,
    required this.servicesSelected,
    required this.minMonthDuration,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'departmentType': departmentType,
      'bedroomsAmount': bedroomsAmount,
      'bathroomsAmount': bathroomsAmount,
      'images': images,
      'imagesUrls': imagesUrls,
      'location':
          location != null
              ? {
                'latitude': location!.latitude,
                'longitude': location!.longitude,
              }
              : null,
      'size': size,
      'description': description,
      'deposit': deposit,
      'depositAmount': depositAmount,
      'monthlyPaymentAmount': monthlyPaymentAmount,
      'monthlyPaymentType': monthlyPaymentType,
      'petsAllowed': petsAllowed,
      'petsAllowedSelected': petsAllowedSelected,
      'petsAmount': petsAmount,
      'partyAllowed': partyAllowed,
      'smokingAllowed': smokingAllowed,
      'disablePeopleAllowed': disablePeopleAllowed,
      'servicesSelected': servicesSelected,
      'minMonthDuration': minMonthDuration,
    };
  }

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      uid: map['uid'] ?? '',
      departmentType: map['departmentType'],
      bedroomsAmount: map['bedroomsAmount'],
      bathroomsAmount: map['bathroomsAmount'],
      images: [],
      imagesUrls: List<String>.from(map['imagesUrls']),
      location:
          map['location'] != null
              ? LatLng(
                map['location']['latitude'],
                map['location']['longitude'],
              )
              : null,
      size: map['size'],
      description: map['description'],
      deposit: map['deposit'],
      depositAmount: map['depositAmount'],
      monthlyPaymentAmount: map['monthlyPaymentAmount'],
      monthlyPaymentType: map['monthlyPaymentType'],
      petsAllowed: map['petsAllowed'],
      petsAllowedSelected:
          map['petsAllowedSelected'] != null
              ? List<String>.from(map['petsAllowedSelected'])
              : null,
      petsAmount: map['petsAmount'],
      partyAllowed: map['partyAllowed'],
      smokingAllowed: map['smokingAllowed'],
      disablePeopleAllowed: map['disablePeopleAllowed'],
      servicesSelected: List<String>.from(map['servicesSelected']),
      minMonthDuration: map['minMonthDuration'],
    );
  }

  bool get hasImages => images.isEmpty;

  Widget _rowContent(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 18))),
        ],
      ),
    );
  }

  Widget buildPropertyDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowContent('Tipo de departamento', departmentType),
          _rowContent('Habitaciones', bedroomsAmount.toString()),
          _rowContent('Baños', bathroomsAmount.toString()),
          _rowContent('Tamaño', '${size} m²'),

          const Section(text: 'Descripción:'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text(
              description,
              style: const TextStyle(fontSize: 18),
            ),
          ),

          _rowContent(
            'Monto mensual',
            '${monthlyPaymentAmount} ${monthlyPaymentType}',
          ),

          _rowContent('Depósito requerido', deposit ? 'Sí' : 'No'),
          if (deposit && depositAmount != null)
            _rowContent('Monto del depósito', depositAmount!),

          _rowContent(
            'Se permiten mascotas',
            petsAllowed ? 'Sí' : 'No',
          ),
          if (petsAllowed) ...[
            if (petsAllowedSelected?.isNotEmpty ?? false)
              _rowContent(
                'Tipos de mascotas permitidas',
                petsAllowedSelected!.join(', '),
              ),
            if (petsAmount != null)
              _rowContent(
                'Cantidad máxima de mascotas',
                petsAmount.toString(),
              ),
          ],

          _rowContent(
            'Fiestas permitidas',
            partyAllowed ? 'Sí' : 'No',
          ),
          _rowContent(
            'Se permite fumar',
            smokingAllowed ? 'Sí' : 'No',
          ),
          _rowContent(
            'Acceso para personas con discapacidad',
            disablePeopleAllowed ? 'Sí' : 'No',
          ),
          Section(text: 'Servicios Incluidos'),
          ...servicesSelected
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(item, style: const TextStyle(fontSize: 18)),
                ),
              ),
          _rowContent('Duración mínima', '${minMonthDuration} meses'),
        ],
      ),
    );
  }
}
