import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final TextStyle? style;
  final int maxLines;
  final bool autofocus;

  const AppTextField({
    super.key,
    required this.controller,
    this.hint,
    this.style,
    this.maxLines = 1,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
      ),
      style: style,
    );
  }
}
