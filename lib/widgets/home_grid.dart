import 'package:flutter/material.dart';

class HomeGrid extends StatelessWidget {
  const HomeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4C8479), Color(0xFF4C8479), Color(0xFF2B524A)],
              stops: [0.0304, 0.441, 0.9744],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: const Stack(
            children: [
              Positioned(
                left: 10,
                top: 10,
                child: Text(
                  'Overlay Text',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
