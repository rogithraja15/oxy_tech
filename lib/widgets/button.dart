import 'package:flutter/material.dart';
import 'package:oxy_tech/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizeh(context) * 0.055,
      width: double.infinity,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(28.0),
        child: Ink(
          decoration: BoxDecoration(
            gradient: buttonGradient,
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(28.0),
            onTap: onPressed,
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton2 extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButton2({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizeh(context) * 0.055,
      width: double.infinity,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(28.0),
        child: Ink(
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor,
            borderRadius: BorderRadius.circular(28.0),
            border: Border.all(
              color: AppTheme.primaryColor, // Set the border color
              width: 2.0, // Adjust the border width
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(28.0),
            onTap: onPressed,
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                    color: AppTheme.primaryColor, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
