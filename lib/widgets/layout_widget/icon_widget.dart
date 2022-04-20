import 'package:flutter/material.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class IconWidget extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;

  const IconWidget({
    Key? key,
    required this.icon,
    this.size = 16,
    this.color = rabbit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(icon,
      size: size,
      color: color,
    );
  }
}
