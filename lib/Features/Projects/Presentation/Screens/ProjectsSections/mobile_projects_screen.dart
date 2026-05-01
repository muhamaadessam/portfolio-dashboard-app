import 'package:flutter/material.dart';

import '../../../../Footer/mobile_footer_section.dart';
import '../projects_section.dart';

class MobileProjectsScreen extends StatelessWidget {
  const MobileProjectsScreen({super.key});

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

                  ProjectsSection(
                    inHome: false,
                  ),
                  // MobileAboutMeSection(inHome: false,),
                  // MobileSkillsSection(inHome: false,),
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
