// GENERATED FILE - DO NOT EDIT
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../home.dart';

class HomeScreen extends BaseView<HomeCubit, HomeState> {
  HomeScreen({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) =>
      CustomAppBar(title: 'Home Screen', withBack: false);

  @override
  Widget body(BuildContext context, HomeState state) {
    final cubit = context.read<HomeCubit>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RefreshIndicator(
        onRefresh: () {
          return cubit.initState();
        },
        child: SingleChildScrollView(
          child: Column(
            spacing: 16.h,
            children: [
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  cubit.gridItems.length,
                  (index) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.mainColor),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .center,
                      spacing: 10.h,
                      children: [
                        TextBody14(cubit.gridItems[index]),
                        TextBody14(cubit.gridValues[index].toString()),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: List.generate(
                  4,
                  (index) => _sectionsItem(
                    context,
                    title: cubit.sectionsTitles[index],
                    newScreen: cubit.sectionsScreens[index],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionsItem(
    BuildContext context, {
    required Widget newScreen,
    required String title,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: GestureDetector(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => newScreen));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.mainColor),
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: TextTitle(title),
        ),
      ),
    );
  }
}
