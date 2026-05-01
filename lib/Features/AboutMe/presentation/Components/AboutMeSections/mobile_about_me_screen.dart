import 'package:flutter/material.dart';

import '../../../../Footer/mobile_footer_section.dart';
import '../../../../Skills/Presentation/Components/Sections/mobile_skills_section.dart';
import '../HomeSections/mobile_about_me_section.dart';
import '../MyFunFactsSections/mobile_fun_fact_section.dart';

class MobileAboutMeScreen extends StatelessWidget {
  const MobileAboutMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Important for scroll views
                spacing: 32,
                children: [
                  MobileAboutMeSection(
                    inHome: false,
                  ),
                  MobileSkillsSection(
                    inHome: false,
                  ),
                  MobileFunFactSection(),
                ],
              ),
            ),
            MobileFooterSection(),
          ],
        ),
      ),
    );
  }
}
