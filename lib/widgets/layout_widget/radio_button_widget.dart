import 'package:flutter/material.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class RadioButtonWidget extends StatelessWidget {
  final int index;
  final int groupValue;
  final ValueChanged<int>? onChanged;
  final Color activeColor;

  const RadioButtonWidget({
    Key? key,
    required this.index,
    required this.groupValue,
    required this.onChanged,
    this.activeColor = rabbit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Radio<int>(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
        vertical: VisualDensity.minimumDensity,
      ),
      activeColor: activeColor,
      groupValue: groupValue,
      value: index,
      onChanged:(newValue) => onChanged,
    );
  }
}
