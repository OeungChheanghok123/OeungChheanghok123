import 'package:flutter/material.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class TextFieldWidget extends StatelessWidget {
  final TextInputType inputType;
  final double height;
  final double width;
  final TextAlign textAlign;
  final double fontSize;
  final int maxLine;
  final Color textColor;
  final FontWeight fontWeight;
  final EdgeInsets contentPadding;
  final String hintText;
  final String errorText;
  final Color hintColor;
  final double borderRadius;
  final double marginVertical;
  final bool isSuffixIcon;
  final bool isPrefixIcon;
  final Icon suffixIcon;
  final Icon prefixIcon;
  final bool readOnly;
  final TextEditingController controller;

  const TextFieldWidget({
    Key? key,
    required this.inputType,
    required this.height,
    required this.controller,
    this.width = double.infinity,
    this.textAlign = TextAlign.start,
    this.fontSize = 12,
    this.maxLine = 1,
    this.textColor = black,
    this.fontWeight = FontWeight.normal,
    this.contentPadding = const EdgeInsets.fromLTRB(10, 0, 0, 0),
    this.hintText = '',
    this.errorText = '',
    this.hintColor = silver,
    this.borderRadius = 5,
    this.marginVertical = 10,
    this.isSuffixIcon = false,
    this.isPrefixIcon = false,
    this.suffixIcon = const Icon(null),
    this.prefixIcon = const Icon(null),
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: marginVertical),
      height: height,
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        textAlign: textAlign,
        autocorrect: false,
        readOnly: readOnly,
        textAlignVertical: TextAlignVertical.center,
        maxLines: maxLine,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
        ),
        decoration: InputDecoration(
          contentPadding: contentPadding,
          hintText: hintText,
          suffixIcon: isSuffixIcon ? suffixIcon : null,
          prefixIcon: isPrefixIcon ? prefixIcon : null,
          errorText: null,
          hintStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: hintColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            borderSide: const BorderSide(color: silver),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            borderSide: const BorderSide(color: silver),
          ),
        ),
      ),
    );
  }
}