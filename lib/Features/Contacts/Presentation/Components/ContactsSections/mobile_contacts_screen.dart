import 'package:flutter/material.dart';

import '../../../../Footer/mobile_footer_section.dart';
import '../HomeSections/mobile_contacts_section.dart';

class MobileContactsScreen extends StatelessWidget {
  const MobileContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Important for scroll views
                  spacing: 32,
                  children: [
                    MobileContactsSection(
                      inHome: false,
                    ),
                    // ProjectsSection(inHome: false,),
                    // MobileAboutMeSection(inHome: false,),
                    // MobileSkillsSection(inHome: false,),
                  ],
                ),
              ),
            ),
          ),
          MobileFooterSection(),
        ],
      ),
    );
  }
}
