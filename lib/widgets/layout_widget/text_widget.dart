import 'package:flutter/material.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final double size;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final Color color;
  final bool isTitle;
  final TextOverflow textOverflow;

  const TextWidget({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.size = 12,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.color = black,
    this.isTitle = false,
    this.textOverflow = TextOverflow.clip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(text,
    textAlign: textAlign,
    overflow: textOverflow,
    style: isTitle ? TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: color,
    ) : TextStyle(
      fontSize: size,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
    ),
  );
}
