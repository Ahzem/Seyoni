import 'package:flutter/material.dart';
import '../providers-list/list_of_providers.dart';
import './components/subcategories.dart'; // Import subcategories

class SubCategoryPage extends StatefulWidget {
  final String category;
  final String? selectedCity;

  const SubCategoryPage({super.key, required this.category, this.selectedCity});

  @override
  SubCategoryPageState createState() => SubCategoryPageState();
}

class SubCategoryPageState extends State<SubCategoryPage> {
  final List<String> _selectedSubCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Subcategories for ${widget.category}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: subCategories[widget.category]?.length ?? 0,
                itemBuilder: (context, index) {
                  String subCategory = subCategories[widget.category]![index];
                  return CheckboxListTile(
                    title: Text(subCategory),
                    value: _selectedSubCategories.contains(subCategory),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedSubCategories.add(subCategory);
                        } else {
                          _selectedSubCategories.remove(subCategory);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ListOfProviders(
                      selectedLocation: widget.selectedCity ?? '',
                      selectedSubCategories: _selectedSubCategories,
                    ),
                  ),
                );
              },
              child: const Text('Find'),
            ),
          ],
        ),
      ),
    );
  }
}
