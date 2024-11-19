import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_image_picker/my_image_picker/my_image_picker.dart';

import 'image_button.dart';
import 'my_border.dart';

class MyImagePickerContent extends StatefulWidget {
  const MyImagePickerContent({
    super.key,
    required this.images,
    this.min,
    this.max,
    required this.onChanged,
    required this.gridCount,
    required this.spacing,
    required this.runSpacing,
    required this.source,
    this.title,
    this.hint,
  });

  final List<XFile> images;
  final int? min;
  final int? max;
  final int gridCount;
  final double spacing;
  final double runSpacing;
  final ImageSource? source;
  final ValueChanged<List<XFile>> onChanged;
  final String? title;
  final String? hint;

  @override
  State<MyImagePickerContent> createState() => MyImagePickerContentState();
}

class MyImagePickerContentState extends State<MyImagePickerContent> {
  late List<XFile> images;

  @override
  void initState() {
    super.initState();
    images = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int grid = widget.max == 1 ? 1 : widget.gridCount;
        double remainWidth = (constraints.maxWidth - widget.spacing * (grid - 1));
        double width = remainWidth / grid;
        return Wrap(
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          children: [
            ...images.map(
              (e) => _buildImageItem(e, width),
            ),
            if (widget.max == null || images.length < widget.max!)
              SizedBox(
                height: 120,
                width: images.isEmpty ? constraints.maxWidth : width,
                child: ImageButton(
                  onTap: () => _pickImage(context),
                  title: widget.title,
                  hint: widget.hint,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildImageItem(XFile image, double width) {
    return SizedBox(
      width: width,
      height: 120,
      child: Stack(
        children: [
          Positioned.fill(
            child: MyBorder(
              child: Image.file(File(image.path)),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: () => _onDeleteImage(index: images.indexOf(image)),
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onDeleteImage({int? index}) async {
    if (index != null) {
      if (index >= 0 && index < images.length) {
        images.removeAt(index);
      }
    } else {
      images.removeLast();
    }
    setState(() {});
    widget.onChanged(images);
  }

  Future<void> _pickImage(context, {int? index}) async {
    XFile? pickedImage = await MyImagePicker.pickImage(
      context,
      source: widget.source,
    );
    if (!mounted || pickedImage == null) return;
    setState(() {
      if (index != null && index >= 0 && index < images.length) {
        images[index] = pickedImage;
      } else {
        images.add(pickedImage);
      }
      widget.onChanged(images);
    });
  }
}
