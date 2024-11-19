import 'package:flutter/material.dart';
import 'package:my_image_picker/my_image_picker/my_border.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    super.key,
    this.onTap,
    this.title,
    this.hint,
    this.color,
    this.icon,
  });

  final VoidCallback? onTap;
  final String? title;
  final String? hint;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmall = constraints.maxWidth < 200;
        return MyBorder(
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: color ?? Colors.grey.shade50,
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSmall) const Icon(Icons.camera),
                    if (!isSmall)
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title ?? 'Upload Gambar',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              hint ?? 'Gambar akan dikompres dan dikirimkan ke server',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
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
        );
      },
    );
  }
}
