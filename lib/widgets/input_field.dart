import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key, 
    required this.icon, 
    required this.hint, 
    this.obsecure, 
    required this.textEditingController, 
    this.enable = true, 
    this.onTapBox});
  final String icon;
  final String hint;
  final bool? obsecure;
  final TextEditingController textEditingController;
  final bool enable;
  final VoidCallback? onTapBox;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBox,
      child: TextField(
        controller: textEditingController,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:  Color(0xff070623),
          ),
        obscureText: obsecure ?? false,
        decoration: InputDecoration(
          enabled: enable,
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color:  Color(0xff070623),
          ),
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          isDense: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              width: 2,
              color: Color(0xff4a1dff),
            ),
          ),
          prefixIcon: UnconstrainedBox(
            alignment: const Alignment(0.2, 0),
            child: Image.asset(
              icon,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}