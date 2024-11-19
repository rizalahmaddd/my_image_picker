import 'package:flutter/material.dart';

/// Custom border widget used for wrapping image items.
class MyBorder extends StatelessWidget {
  const MyBorder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}
