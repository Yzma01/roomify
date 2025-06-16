import 'package:flutter/material.dart';
import 'package:roomify/components/home/Filters.dart';
import 'package:roomify/components/home/Places.dart';
import 'package:roomify/components/inputs/Search.dart';
import 'package:roomify/models/Property.dart';
import 'package:roomify/services/filter_properties_service.dart';
import 'package:roomify/services/firebase_services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchValue = TextEditingController();
  Map<String, dynamic> _filters = {};
  List<Property> _allProperties = [];
  List<Property> _filteredProperties = [];
  List<String> _availableServices = [];
  bool _loadingServices = false;
  bool _isloadingProperties = true;

  Map<String, dynamic> _currentFilters = {
    'bedrooms': '0',
    'pets': false,
    'parties': false,
    'smoking': false,
    'accessible': false,
    'departmentType': null,
    'minRentalDuration': null,
    'services': [],
  };

  @override
  void initState() {
    super.initState();
    _loadProperties();
    _loadServices();
    _filteredProperties = _allProperties;
  }

  Future<void> _loadServices() async {
    setState(() => _loadingServices = true);
    try {
      final services = await getServices();
      setState(() => _availableServices = services);
    } catch (e) {
      print('Error loading services: $e');
    } finally {
      setState(() => _loadingServices = false);
    }
  }

  Future<void> _loadProperties() async {
    setState(() => _isloadingProperties = true);
    try {
      final properties = await getProperties();
      setState(() {
        _allProperties = properties;
        _filteredProperties = properties;
        _isloadingProperties = false;
      });
    } catch (e) {
      print('Error loading properties: $e');
      setState(() => _isloadingProperties = false);
      setState(() {
        _allProperties = [];
        _filteredProperties = [];
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar propiedades')));
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _filters = filters;
      _filteredProperties = FilterPropertiesService.filterProperties(
        properties: _allProperties,
        filters: filters,
      );
    });
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Filter(
                onApply: (newFilters) {
                  _currentFilters = newFilters;
                  _applyFilters(newFilters);
                },
                initialFilters: _currentFilters,
                availableServices: _availableServices,
              ),
            ),
          ),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
    );
  }

  void _search() {
    final query = _searchValue.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProperties = FilterPropertiesService.filterProperties(
          properties: _allProperties,
          filters: _filters,
        );
      } else {
        _filteredProperties =
            FilterPropertiesService.filterProperties(
                  properties: _allProperties,
                  filters: _filters,
                )
                .where(
                  (property) =>
                      property.description.toLowerCase().contains(query) ||
                      (property.departmentType?.toLowerCase().contains(query) ??
                          false),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Search(
              controller: _searchValue,
              //label: 'Lugar',
              label: 'No disponible',
              prefixIcon: IconButton(
                onPressed: _search,
                icon: Icon(Icons.search),
              ),
              suffixIcon: IconButton(
                onPressed: _showFilters,
                icon: Icon(Icons.tune),
              ),
              padding: EdgeInsets.all(20),
            ),
            Expanded(
              child: Places(
                properties: _filteredProperties,
                isLoading: _isloadingProperties,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
