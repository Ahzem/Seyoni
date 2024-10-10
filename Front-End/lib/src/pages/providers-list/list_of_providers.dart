import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/constants_color.dart';
import '../../widgets/background_widget.dart';
import 'components/provider_card.dart';
import '../../config/url.dart'; // Import the URL constants

class ListOfProviders extends StatefulWidget {
  final String selectedLocation;
  final List<String> selectedSubCategories;

  const ListOfProviders({
    super.key,
    required this.selectedLocation,
    required this.selectedSubCategories,
  });

  @override
  ListOfProvidersState createState() => ListOfProvidersState();
}

class ListOfProvidersState extends State<ListOfProviders> {
  List<dynamic> filteredProviders = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProviders();
  }

  Future<void> _fetchProviders() async {
    try {
      final response = await http.get(Uri.parse('$url/api/providers'));
      if (response.statusCode == 200) {
        final providers = json.decode(response.body);
        _filterProviders(providers);
      } else {
        throw Exception('Failed to load providers');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load providers';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterProviders(List<dynamic> providers) {
    setState(() {
      filteredProviders = providers.where((provider) {
        return provider['location'].contains(widget.selectedLocation) &&
            provider['subCategories'].any((subCategory) =>
                widget.selectedSubCategories.contains(subCategory));
      }).toList();
      isLoading = false;
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
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : filteredProviders.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredProviders.length,
                          itemBuilder: (context, index) {
                            final provider = filteredProviders[index];
                            return ProviderCard(
                              providerId: provider['_id'].toString(),
                              name: provider['name'],
                              imageUrl: provider['imageUrl'],
                              rating: provider['rating'].toDouble(),
                              profession: provider['profession'],
                              completedWorks: provider['completedWorks'],
                              isAvailable: provider['isAvailable'],
                            );
                          },
                        )
                      : Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'No providers available for this location and subcategories.',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Refine Search',
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor)),
                                ),
                              ],
                            ),
                          ),
                        ),
        ),
      ],
    );
  }
}
