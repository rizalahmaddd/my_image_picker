library my_image_picker;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_image_picker/my_image_picker/my_image_picker_content.dart';

/// MyImagePicker adalah widget untuk memilih gambar dari galeri atau kamera.
///
/// Gunakan [MyImagePicker] dalam form untuk memvalidasi dan menangani gambar yang dipilih pengguna.
class MyImagePicker extends FormField<List<XFile>> {
  MyImagePicker({
    super.key,
    List<XFile>? initialValue,
    this.min,
    this.max,
    required this.onChanged,
    this.gridCount = 4,
    this.spacing = 8,
    this.runSpacing = 8,
    this.source,
    this.quality = 80,
    this.maxHeight = 1000,
    this.maxWidth = 1000,
    this.title,
    this.hint,
  }) : super(
          initialValue: initialValue ?? [],
          validator: (images) {
            if (min != null && (images?.length ?? 0) < min) {
              return 'Minimal $min gambar diperlukan.';
            }
            if (max != null && (images?.length ?? 0) > max) {
              return 'Maksimal $max gambar diperbolehkan.';
            }
            return null;
          },
          builder: (FormFieldState<List<XFile>> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyImagePickerContent(
                  title: title,
                  hint: hint,
                  images: state.value ?? [],
                  min: min,
                  max: max,
                  gridCount: gridCount,
                  spacing: spacing,
                  runSpacing: runSpacing,
                  source: source,
                  onChanged: (images) {
                    state.didChange(images);
                    onChanged(images);
                  },
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            );
          },
        );

  final int? min;
  final int? max;
  final int gridCount;
  final ValueChanged<List<XFile>> onChanged;
  final double spacing;
  final double runSpacing;
  final ImageSource? source;
  final int quality;
  final double maxHeight;
  final double maxWidth;
  final String? title;
  final String? hint;

  static Future<XFile?> pickImage(
    context, {
    ImageSource? source,
    int? quality,
    double? maxHeight,
    double? maxWidth,
  }) async {
    source ??= await selectImageSource(context);
    if (source == null) return null;
    return await ImagePicker().pickImage(
      source: source,
      imageQuality: quality,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
  }

  static Future<ImageSource?> selectImageSource(BuildContext context) async {
    return showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(12),
          contentPadding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            'Pilih Gambar',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                ),
            textAlign: TextAlign.center,
          ),
          content: Row(
            children: [
              Expanded(
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.image_search_rounded,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Galeri',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.camera,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kamera',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
