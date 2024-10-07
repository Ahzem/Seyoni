import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onPickImage;

  const ImagePickerWidget({
    super.key,
    required this.selectedImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.4)),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.white.withOpacity(0.1),
            child: Column(
              children: [
                Icon(Icons.add_a_photo, size: 24, color: kPrimaryColor),
                SizedBox(width: 10),
                TextButton(
                  onPressed: onPickImage,
                  child: Text(
                    "Add Image",
                    style: kBodyTextStyle,
                  ),
                ),
                if (selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Image.file(
                      selectedImage!,
                      width: 50,
                      height: 50,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
