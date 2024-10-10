import 'package:flutter/material.dart';
import 'package:seyoni/src/widgets/custom_button.dart';
import 'dart:ui'; // For blur effect
import '../../constants/constants_color.dart';
import '../providers-list/list_of_providers.dart';
import './components/subcategories.dart'; // Import subcategories

class SubCategoryBottomSheet extends StatefulWidget {
  final String category;
  final String? selectedCity;

  const SubCategoryBottomSheet(
      {super.key, required this.category, this.selectedCity});

  @override
  SubCategoryBottomSheetState createState() => SubCategoryBottomSheetState();
}

class SubCategoryBottomSheetState extends State<SubCategoryBottomSheet> {
  final List<String> _selectedSubCategories = [];

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8, // Decrease height
        decoration: const BoxDecoration(
          color: Color.fromARGB(6, 255, 255, 255),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(color: Colors.white70, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Subcategories for ${widget.category}',
                style: const TextStyle(
                    fontSize: 20,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: subCategories[widget.category]?.length ?? 0,
                  itemBuilder: (context, index) {
                    String subCategory = subCategories[widget.category]![index];
                    return CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: kPrimaryColor,
                      side: const BorderSide(color: kPrimaryColor),
                      shape: const CircleBorder(), // Make it a circle
                      title: Text(subCategory,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryOutlinedButton(
                      text: 'Cancel',
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  PrimaryFilledButton(
                      text: 'Find',
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
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
