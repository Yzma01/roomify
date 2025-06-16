import 'package:roomify/models/Property.dart';

class FilterPropertiesService {
  static List<Property> filterProperties({
    required List<Property> properties,
    required Map<String, dynamic> filters,
  }) {
    if (_noFiltersApplied(filters)) {
      return properties;
    }

    return properties.where((property) {
      return _matchesAllFilters(property, filters);
    }).toList();
  }

  static bool _noFiltersApplied(Map<String, dynamic> filters) {
    return filters.isEmpty ||
        (filters['bedrooms'] == '0' &&
            filters['pets'] == false &&
            filters['parties'] == false &&
            filters['smoking'] == false &&
            filters['accessible'] == false &&
            filters['departmentType'] == null &&
            filters['minRentalDuration'] == null &&
            (filters['services'] as List).isEmpty);
  }

  static bool _matchesAllFilters(Property property, Map<String, dynamic> filters) {
    return _matchesBedrooms(property, filters) &&
        _matchesPets(property, filters) &&
        _matchesParties(property, filters) &&
        _matchesSmoking(property, filters) &&
        _matchesPropertyType(property, filters) &&
        _matchesRentalDuration(property, filters) &&
        _matchesServices(property, filters) &&
        _matchesAccessibility(property, filters);
  }

  static bool _matchesBedrooms(Property property, Map<String, dynamic> filters) {
    if (!filters.containsKey('bedrooms')) return true;
    return property.bedroomsAmount >= int.parse(filters['bedrooms']);
  }

  static bool _matchesPets(Property property, Map<String, dynamic> filters) {
    if (!filters.containsKey('pets')) return true;
    if (filters['pets'] == false) return true;
    return property.petsAllowed == true;
  }

  static bool _matchesParties(Property property, Map<String, dynamic> filters) {
    if (!filters.containsKey('parties')) return true;
    if (filters['parties'] == false) return true;
    return property.partyAllowed == true;
  }

  static bool _matchesSmoking(Property property, Map<String, dynamic> filters) {
    if (!filters.containsKey('smoking')) return true;
    if (filters['smoking'] == false) return true;
    return property.smokingAllowed == true;
  }

  static bool _matchesPropertyType(Property property, Map<String, dynamic> filters) {
    if (!filters.containsKey('departmentType')) return true;
    return property.departmentType == filters['departmentType'];
  }

  static bool _matchesRentalDuration(Property property, Map<String, dynamic> filters) {
    if (!filters.containsKey('minRentalDuration')) return true;
    // TODO Implementar lógica específica para comparar duraciones
    return true;
  }

  static bool _matchesServices(Property property, Map<String, dynamic> filters) {
    if (!filters.containsKey('services')) return true;
    if ((filters['services'] as List).isEmpty) return true;
    
    final requiredServices = filters['services'] as List<String>;
    return requiredServices.every((service) => 
        property.servicesSelected.contains(service));
  }

  static bool _matchesAccessibility(Property property, Map<String, dynamic> filters) {
    if (!filters.containsKey('accessible')) return true;
    if (filters['accessible'] == false) return true;
    return property.disablePeopleAllowed == true;
  }
}