
import 'package:flutter/material.dart';

class BaseBackgroundWidget extends StatelessWidget {
  const BaseBackgroundWidget({
    super.key,
    required this.backgroundColors,
  });

  final List<Color>? backgroundColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-1.5, -1.0),
          end: const Alignment(1.5, 1.0),
          colors: backgroundColors ??
              [
                const Color(0xFF1A1F3D),
                const Color(0xFF15192B),
                const Color.fromARGB(255, 55, 56, 59),
              ],
        ),
      ),
    );
  }
}
