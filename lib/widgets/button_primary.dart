import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary({super.key, required this.text, required this.onTap});
  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50),
      color: Color(0xffffbc1c),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: Center(
            child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color:  Color(0xff070623),
                ),
                textAlign: TextAlign.left,
              ),
          ),
        ),
      ),
    );
  }
}