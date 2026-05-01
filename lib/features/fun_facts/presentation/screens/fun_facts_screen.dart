// GENERATED FILE - DO NOT EDIT
import 'package:flutter/material.dart';
import '../../fun_facts.dart';


class FunFactsScreen extends BaseView<FunFactsCubit, FunFactsState> {
   FunFactsScreen({super.key});
@override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
    title: const Text('FunFacts Screen'),
  );

  @override
  Widget body(BuildContext context, FunFactsState state) {
    return Center(
      child: Text('Welcome to FunFacts feature!'),
    );
  }
}
