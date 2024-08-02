import 'package:flutter/material.dart';
import 'package:oxy_tech/utils/constants.dart';

class CustomTextField extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: sizew(context) * 0.02),
      child: SizedBox(
        height: sizeh(context) * 0.058,
        child: TextFormField(
          controller: widget.controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTheme.hintTextStyle(context),
            prefixIcon: Icon(
              widget.icon,
              color: AppTheme.secondaryColor,
              size: sizew(context) * 0.06,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.0),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.0),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.0),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField2 extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;

  const CustomTextField2({
    super.key,
    required this.icon,
    required this.hintText,
    required this.controller,
  });

  @override
  State<CustomTextField2> createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: sizew(context) * 0.02),
      child: SizedBox(
        height: sizeh(context) * 0.058,
        child: TextFormField(
          controller: widget.controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTheme.hintTextStyle(context)
                .copyWith(color: Colors.white.withOpacity(0.53)),
            prefixIcon: Icon(
              widget.icon,
              color: Colors.white.withOpacity(0.53),
              size: sizew(context) * 0.05,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.0),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.0),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.0),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
