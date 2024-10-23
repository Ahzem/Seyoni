import 'package:flutter/material.dart';
import '../../../widgets/background_widget.dart';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';
import '../category/category_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Common padding and spacing constants
  final double spacing = 20.0;
  final EdgeInsets commonPadding = const EdgeInsets.all(20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Container(
            padding: commonPadding,
            color: Colors.transparent.withOpacity(0.1),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
              children: [
                // Categories Section
                _buildSectionTitle('Categories', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage()),
                  );
                }),
                const SizedBox(height: 10.0), // Space between title and categories

                // Categories Scroll
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_categories.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(right: spacing),
                        child: buildCategoryContainer(_categories[index]['title']!, _categories[index]['image']!),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 30.0), // Space between sections
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: kSecondaryColor, thickness: 1.0),
                ),

                // Recent Workers Section
                _buildSectionTitle('Recent Workers'),
                const SizedBox(height: 10.0),

                // Static Row for Recent Workers
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_recentWorkers.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(right: spacing),
                        child: buildWorker(_recentWorkers[index]['name']!, _recentWorkers[index]['image']!),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 30.0), // Space between sections

                // Reusable sections for Cleaning, Electrical, and Plumbing Services
                _buildServiceSection('Cleaning Service', _cleaningServices),
                _buildServiceSection('Electrical Service', _electricServices),
                _buildServiceSection('Plumbing Service', _plumbingServices),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section title builder
  Widget _buildSectionTitle(String title, [VoidCallback? onSeeAll]) {
    return Row(
      children: [
        Text(title, style: kTitleTextStyleBold),
        const Spacer(),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text('See all', style: kBodyTextStyle),
          ),
      ],
    );
  }

  // Generic service section builder
  Widget _buildServiceSection(String title, List<Map<String, String>> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 10.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(services.length, (index) {
              return Padding(
                padding: EdgeInsets.only(right: spacing),
                child: buildServiceContainer(services[index]['title']!, services[index]['image']!),
              );
            }),
          ),
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }

  // Helper method to build a category container
  Widget buildCategoryContainer(String title, String imagePath) {
    return SizedBox(
      width: 100.0,
      height: 100.0,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 40.0,
              width: 40.0,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
            const SizedBox(height: 10.0),
            Text(title, style: kBodyTextStyle2, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // Helper method to build a worker container
  Widget buildWorker(String name, String imagePath) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 8.0),
        Text(name, style: kBodyTextStyle2),
      ],
    );
  }

  // Helper method to build a service container
  Widget buildServiceContainer(String title, String imagePath) {
    return SizedBox(
      width: 180.0,
      height: 200.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 130.0,
            width: 130.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            width: 150.0,
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(title, style: kBodyTextStyle2, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  // Mock data for categories and services
  final List<Map<String, String>> _categories = [
    {'title': 'Cleaner', 'image': 'assets/icons/Category/Housekeeping.png'},
    {'title': 'Electrician', 'image': 'assets/icons/Category/Electrician.png'},
    {'title': 'Plumber', 'image': 'assets/icons/Category/Plumbing.png'},
    {'title': 'Carpenter', 'image': 'assets/icons/Category/Carpenter.png'},
    {'title': 'Babysitter', 'image': 'assets/icons/Category/Day Care.png'},
    {'title': 'Gardener', 'image': 'assets/icons/Category/Gardner.png'},
    {'title': 'Mason', 'image': 'assets/icons/Category/Masons.png'},
  ];

  final List<Map<String, String>> _recentWorkers = [
    {'name': 'Antony', 'image': 'assets/images/profile-1.jpg'},
    {'name': 'John', 'image': 'assets/images/profile-2.jpg'},
    {'name': 'Michel', 'image': 'assets/images/profile-3.jpg'},
    {'name': 'Selva', 'image': 'assets/images/profile-4.jpg'},
  ];

  final List<Map<String, String>> _cleaningServices = [
    {'title': 'Regular Cleaning', 'image': 'assets/images/regular.jpg'},
    {'title': 'Window Cleaning', 'image': 'assets/images/window.jpg'},
    {'title': 'Carpet Cleaning', 'image': 'assets/images/carpet.jpg'},
    {'title': 'Upholstery Cleaning', 'image': 'assets/images/Upholstery.jpg'},
  ];

  final List<Map<String, String>> _electricServices = [
    {'title': 'Electrical Wiring', 'image': 'assets/images/wiring.png'},
    {'title': 'Circuit Breaker Install', 'image': 'assets/images/CBinstall.jpg'},
    {'title': 'Lightning Installation', 'image': 'assets/images/lightning.jpg'},
    {'title': 'Generator Installation', 'image': 'assets/images/generator.png'},
  ];

  final List<Map<String, String>> _plumbingServices = [
    {'title': 'Leak Repair', 'image': 'assets/images/leak.jpg'},
    {'title': 'Pipe Installation', 'image': 'assets/images/pipe.jpeg'},
    {'title': 'Faucet and Sink Repair', 'image': 'assets/images/faucet.jpg'},
    {'title': 'Sewer Line Services', 'image': 'assets/images/sewer.jpg'},
  ];
}
