import 'package:flutter/material.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class ImageIconWidget extends StatelessWidget {
  final double size;
  final Color borderColor;
  final Color backgroundColor;
  final String image;

  const ImageIconWidget({
    Key? key,
    required this.image,
    this.size = 30,
    this.borderColor = rabbit,
    this.backgroundColor = rabbit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(width: 2.5, color: borderColor),
      ),
      child: Container(
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
          margin: const EdgeInsets.all(3.5),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}