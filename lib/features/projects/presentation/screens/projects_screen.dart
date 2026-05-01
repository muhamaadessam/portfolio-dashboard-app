// GENERATED FILE - DO NOT EDIT
import 'package:flutter/material.dart';
import '../../projects.dart';


class ProjectsScreen extends BaseView<ProjectsCubit, ProjectsState> {
   ProjectsScreen({super.key});
@override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
    title: const Text('Projects Screen'),
  );

  @override
  Widget body(BuildContext context, ProjectsState state) {
    return Center(
      child: Text('Welcome to Projects feature!'),
    );
  }
}
