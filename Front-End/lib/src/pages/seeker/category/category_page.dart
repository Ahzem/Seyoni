import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../constants/constants_color.dart';
import 'components/categories.dart';
import 'subcategory_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  CategoryPageState createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {
  String? _selectedCity;
  final TextEditingController _typeAheadController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<List<String>> _fetchLocationSuggestions(String input) async {
    final String? apiKey =
        dotenv.env['GOOGLE_PLACES_API_KEY']; // Get the API key from .env
    if (apiKey == null) {
      throw Exception('API key not found');
    }

    final Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=(cities)&key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return (data['predictions'] as List)
            .map((prediction) => prediction['description'] as String)
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _typeAheadController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.location_on, color: kPrimaryColor),
                    label: const Text('Select Nearest City',
                        style: TextStyle(color: Colors.white)),
                    filled: true,
                    helperStyle: const TextStyle(color: kPrimaryColor),
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: kPrimaryColor, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: kPrimaryColor, width: 1),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                suggestionsCallback: (pattern) async {
                  if (pattern.isEmpty) {
                    return [];
                  }
                  return await _fetchLocationSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _typeAheadController.text = suggestion;
                  setState(() {
                    _selectedCity = suggestion;
                  });
                },
                noItemsFoundBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No cities found'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _showSubCategoryBottomSheet(context, category['name']!);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.white.withOpacity(0.8))),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              category['icon']!, // Use the asset icon path
                              color: kPrimaryColor,
                              width: 40,
                              height: 40,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category['name']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubCategoryBottomSheet(BuildContext context, String category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SubCategoryBottomSheet(
          category: category,
          selectedCity: _selectedCity,
        );
      },
    );
  }
}
