import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../constants/constants_color.dart';
import '../../../../constants/constants_font.dart';

class ImagePickerWidget extends StatelessWidget {
  final VoidCallback onPickImage;

  const ImagePickerWidget({
    super.key,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            color: Colors.white.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onPickImage,
                  child: Column(
                    children: [
                      Icon(Icons.add_a_photo, size: 24, color: kPrimaryColor),
                      SizedBox(width: 10),
                      Text(
                        "Add Image",
                        style: kBodyTextStyle,
                      ),
                    ],
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

class SelectedImagesWidget extends StatelessWidget {
  final List<File> selectedImages;

  const SelectedImagesWidget({
    super.key,
    required this.selectedImages,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selectedImages.isNotEmpty)
                    ...selectedImages.map((image) => Padding(
                          padding: const EdgeInsets.all(5),
                          child: Image.file(
                            image,
                            width: 40,
                            height: 40,
                          ),
                        )),
                  if (selectedImages.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 24,
                            color: const Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(0.5),
                          ),
                          Text(
                            "No Image",
                            style: kBodyTextStyle.copyWith(
                              color: const Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
