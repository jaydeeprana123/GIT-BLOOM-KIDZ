import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Styles/my_font.dart';

class DottedLine extends StatelessWidget {
  final double height;
  final double dashWidth;
  final Color color;

  const DottedLine({
    super.key,
    this.height = 1,
    this.dashWidth = 4,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.maxWidth / (dashWidth * 2)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dashCount,
            (_) => SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            ),
          ),
        );
      },
    );
  }
}
