import 'package:flutter/material.dart';
import 'package:portfolio_app/Core/core.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return PolicyDialog(
                mdFileName: 'privacy_policy.md',
              );
            },
          );
        },
        child: TextTitle(
          "سياسة الخصوصية",
          color: const Color(0xffffcc00).withValues(alpha: .8),
        ),
      ),
    );
  }
}
