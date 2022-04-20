import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgPictureWidget extends StatelessWidget {
  final String imageString;
  final String label;
  final BoxFit boxFit;

  const SvgPictureWidget({
    Key? key,
    required this.imageString,
    required this.label,
    this.boxFit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(imageString,
      fit: boxFit,
      placeholderBuilder: (context) => const CircularProgressIndicator(),
      semanticsLabel: label,
    );
  }
}