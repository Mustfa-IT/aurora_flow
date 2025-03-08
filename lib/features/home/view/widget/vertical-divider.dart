import 'package:flutter/material.dart';

class VerticalDividerWidget extends StatelessWidget {
  final double height;
  final double width;
  final double thickness;
  final Color color;

  const VerticalDividerWidget({
    super.key,
    this.height = 40,
    this.width = 25,
    this.thickness = 2,
    this.color = Colors.teal,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: VerticalDivider(
        width: width,
        thickness: thickness,
        color: color,
      ),
    );
  }
}