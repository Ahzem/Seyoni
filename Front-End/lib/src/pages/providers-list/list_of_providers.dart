import 'package:flutter/material.dart';
import '../../widgets/background_widget.dart';
import 'components/provider_card.dart';
import 'components/provider_data.dart';

class ListOfProviders extends StatefulWidget {
  final String selectedLocation;
  final List<String> selectedSubCategories;

  const ListOfProviders(
      {super.key,
      required this.selectedLocation,
      required this.selectedSubCategories});

  @override
  ListOfProvidersState createState() => ListOfProvidersState();
}

class ListOfProvidersState extends State<ListOfProviders> {
  List<ProviderData> filteredProviders = [];

  @override
  void initState() {
    super.initState();
    _filterProviders();
  }

  // Filter based on location and subcategories
  void _filterProviders() {
    setState(() {
      filteredProviders = providers.where((provider) {
        return provider.location.contains(widget.selectedLocation) &&
            provider.subCategories.any((subCategory) =>
                widget.selectedSubCategories.contains(subCategory));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: BackgroundWidget(child: SizedBox.expand()),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Providers in ${widget.selectedLocation}',
                style: const TextStyle(fontSize: 20, color: Colors.white)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: filteredProviders.isNotEmpty
              ? ListView.builder(
                  itemCount: filteredProviders.length,
                  itemBuilder: (context, index) {
                    return ProviderCard(provider: filteredProviders[index]);
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No providers available for this location and subcategories.',
                        style: TextStyle(fontSize: 18),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Refine Search'),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
