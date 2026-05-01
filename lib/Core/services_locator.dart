// GENERATED FILE - DO NOT EDIT

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:portfolio_app/features/home/home_di.dart';

import '../features/projects/projects_di.dart';
import '../features/skills/skills_di.dart';

final di = GetIt.instance;

class ServicesLocator {
  void init() {
    debugPrint("Initializing ServicesLocator...");
    HomeDI();
    SkillsDI();
    ProjectsDI();
    debugPrint("ServicesLocator initialized successfully!");
  }
}
