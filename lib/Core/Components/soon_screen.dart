import 'package:flutter/material.dart';
import 'package:portfolio_app/Core/core.dart';

class SoonScreen extends StatelessWidget {
  const SoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        // Image.asset(
        //   Assets.soon,
        //   width: 300.w,
        // ),
        const Center(
          child: TextTitle(
            'قريبا',
            color: Color(0xffc2c2c2),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
