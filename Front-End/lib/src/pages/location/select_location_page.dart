import 'package:flutter/material.dart';
import '../providers-list/list_of_providers.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  SelectLocationPageState createState() => SelectLocationPageState();
}

class SelectLocationPageState extends State<SelectLocationPage> {
  final List<String> _mainCities = ['Colombo', 'Kandy', 'Galle', 'Jaffna'];

  // Simulated list of real village names
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Main Cities', style: TextStyle(fontSize: 20)),
            Wrap(
              spacing: 10,
              children: _mainCities.map((city) {
                return ChoiceChip(
                  label: Text(city),
                  selected:
                      false, // You can maintain state for selected chips if needed
                  onSelected: (selected) {
                    if (selected) {
                      // Navigate to provider list page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ListOfProviders(
                            selectedLocation: city,
                            selectedSubCategories: [],
                          ),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Or Enter Manually', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
