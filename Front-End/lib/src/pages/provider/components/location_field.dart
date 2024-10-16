import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/services/location_service.dart';

class LocationField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSuggestionSelected;

  const LocationField({
    super.key,
    required this.controller,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      suggestionsCallback: (pattern) async {
        if (pattern.isEmpty) {
          return [];
        }
        return await LocationService.fetchLocationSuggestions(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSelected: (suggestion) {
        controller.text = suggestion;
        onSuggestionSelected(suggestion);
      },
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            label: const Text('Select Nearest City', style: kBodyTextStyle),
            filled: true,
            helperStyle: const TextStyle(color: kPrimaryColor),
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: kPrimaryColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: kPrimaryColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: kPrimaryColor, width: 1),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}
