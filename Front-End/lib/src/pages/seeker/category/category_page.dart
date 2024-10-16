import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../constants/constants_color.dart';
import 'components/categories.dart';
import 'subcategory_page.dart';
import 'package:seyoni/src/services/location_service.dart'; // Import LocationService

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  CategoryPageState createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {
  String? _selectedCity;
  final TextEditingController _typeAheadController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TypeAheadField(
                suggestionsCallback: (pattern) async {
                  if (pattern.isEmpty) {
                    return [];
                  }
                  return await LocationService.fetchLocationSuggestions(
                      pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSelected: (suggestion) {
                  _typeAheadController.text = suggestion;
                  setState(() {
                    _selectedCity = suggestion;
                  });
                },
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
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
                  );
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
                          bottom:
                              BorderSide(color: Colors.white.withOpacity(0.8)),
                        ),
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
