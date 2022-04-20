import 'package:flutter/material.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class TitleAppBarWidget extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final double size;
  final FontWeight fontWeight;
  final Color color;

  const TitleAppBarWidget({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.size = 16,
    this.fontWeight = FontWeight.bold,
    this.color = black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(text,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: size,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}
