import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.icon,
    required this.hintText,
    this.obscureText = false,
    this.fillColor = const Color(0xffeceff4),
    this.validator,
    this.onChanged,
  });
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final Color? fillColor;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        border: textBorderStyle(),
        enabledBorder: textBorderStyle(),
        focusedBorder: textBorderStyle(color: Colors.blue),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        hintStyle: AppTextStyles.inter400style16.copyWith(
          color: Color(0XffADAEBC),
        ),
      ),
    );
  }

  OutlineInputBorder textBorderStyle({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: color ?? Color(0xffE5E7EB), width: 1.2),
    );
  }
}
