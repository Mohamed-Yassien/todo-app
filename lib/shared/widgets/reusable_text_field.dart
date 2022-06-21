import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String textLabel;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final Function validate;
  final VoidCallback? suffixPressed;
  final VoidCallback? onTap;

  ReusableTextField({
    required this.controller,
    this.isPassword = false,
    required this.prefixIcon,
    this.suffixIcon,
    required this.textLabel,
    required this.validate,
    this.suffixPressed,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: textLabel,
          prefixIcon: Icon(
            prefixIcon,
          ),
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon),
                  onPressed: suffixPressed,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      obscureText: isPassword,
      onTap: onTap,
      validator: (val) => validate(val),
    );
  }
}
