import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTab;
  const CustomTextFormField({super.key, required this.label, required this.controller, required this.isPassword, this.prefixIcon, this.suffixIcon, required this.readOnly, this.onTab});

  @override
  Widget build(BuildContext context) {
    return (TextFormField(
      controller: controller,
      obscureText: isPassword,
      readOnly: readOnly,
      onTap: onTab,
      decoration: InputDecoration(labelText:label,prefix:Icon(prefixIcon),suffixIcon: suffixIcon)));
  }
}