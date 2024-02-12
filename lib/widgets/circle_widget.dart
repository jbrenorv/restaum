import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  const CircleWidget({
    super.key,
    this.color,
    this.child,
  });

  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
