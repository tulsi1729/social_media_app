import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const AuthGradientButton(
      {super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7)),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
