
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roomify/models/Property.dart';

class PropertyFilters {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Property>> filterProperties({
    int? minBedrooms,
    int? maxBedrooms,
    bool? petsAllowed,
    bool? partiesAllowed,
    bool? smokingAllowed,
    bool? accessible,
    String? propertyType,
    String? minRentalDuration,
    List<String>? services,
    double? minPrice,
    double? maxPrice,
  }) async {
    Query query = _firestore.collection('properties');

    // Apply each filter if it has a value
    if (minBedrooms != null) {
      query = query.where('bedroomsAmount', isGreaterThanOrEqualTo: minBedrooms);
    }

    if (maxBedrooms != null) {
      query = query.where('bedroomsAmount', isLessThanOrEqualTo: maxBedrooms);
    }

    if (petsAllowed != null) {
      query = query.where('petsAllowed', isEqualTo: petsAllowed);
    }

    if (partiesAllowed != null) {
      query = query.where('partyAllowed', isEqualTo: partiesAllowed);
    }

    if (smokingAllowed != null) {
      query = query.where('smokingAllowed', isEqualTo: smokingAllowed);
    }

    if (accessible != null) {
      query = query.where('disablePeopleAllowed', isEqualTo: accessible);
    }

    if (propertyType != null) {
      query = query.where('departmentType', isEqualTo: propertyType);
    }

    if (minPrice != null) {
      query = query.where('monthlyPaymentAmount',
          isGreaterThanOrEqualTo: minPrice.toString());
    }

    if (maxPrice != null) {
      query = query.where('monthlyPaymentAmount',
          isLessThanOrEqualTo: maxPrice.toString());
    }

    final querySnapshot = await query.get();

    List<Property> properties = querySnapshot.docs
        .map((doc) {
          final  data = doc.data() as Map<String, dynamic>;
          data['uid'] = doc.id;
          return Property.fromMap(data);
        })
        .toList();

    // Apply filters that can't be done in Firestore query
    if (minRentalDuration != null) {
      properties = properties.where((property) {
        return _compareRentalDurations(
            property.minMonthDuration, minRentalDuration);
      }).toList();
    }

    if (services != null && services.isNotEmpty) {
      properties = properties.where((property) {
        return services.every(
            (service) => property.servicesSelected?.contains(service) ?? false);
      }).toList();
    }

    return properties;
  }

  bool _compareRentalDurations(String? propertyDuration, String filterDuration) {
    if (propertyDuration == null || filterDuration == 'No es necesario') {
      return true;
    }

    final propertyMonths = _extractMonths(propertyDuration);
    final filterMonths = _extractMonths(filterDuration);

    return propertyMonths >= filterMonths;
  }

  int _extractMonths(String duration) {
    if (duration == 'No es necesario') return 0;
    return int.tryParse(duration.split(' ')[0]) ?? 0;
  }

  Future<List<String>> getPropertyTypes() async {
    final snapshot = await _firestore.collection('properties').get();
    final types = snapshot.docs
        .map((doc) => doc.data()['departmentType'] as String?)
        .where((type) => type != null)
        .toSet()
        .toList();
    return types.cast<String>();
  }

  Future<Map<String, double>> getPriceRange() async {
    final snapshot = await _firestore
        .collection('properties')
        .orderBy('monthlyPaymentAmount')
        .get();

    if (snapshot.docs.isEmpty) {
      return {'min': 0, 'max': 0};
    }

    final minPrice = double.parse(snapshot.docs.first['monthlyPaymentAmount']);
    final maxPrice = double.parse(snapshot.docs.last['monthlyPaymentAmount']);

    return {'min': minPrice, 'max': maxPrice};
  }
}