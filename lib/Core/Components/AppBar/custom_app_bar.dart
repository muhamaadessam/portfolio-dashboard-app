import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_app/Core/core.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.color,
    this.onTap,
    this.withBack = true,
    this.hasElevation = true,
    this.leadingWidth,
    this.leading,
    this.titleWidget,
  });

  final String? title;
  final Color? color;
  final bool withBack;
  final Widget? leading;
  final double? leadingWidth;
  final Widget? titleWidget;
  final void Function()? onTap;
  final bool hasElevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      foregroundColor: context.reverseTextColor,
      backgroundColor: context.appBarColor,
      elevation: hasElevation ? 4 : 0,
      leading: leading,
      leadingWidth: leadingWidth,
      title: titleWidget ??
          TextTitle(
            title ?? '',
            fontSize: 18,
            color: context.reverseTextColor,
          ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(
            Icons.brightness_6,
            color: context.reverseTextColor,
          ),
          onPressed: () {
            context.read<AppThemeCubit>().toggleTheme();
          },
        ),
        if (withBack)
          IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: context.reverseTextColor,
            ),
            onPressed: onTap ?? () => Navigator.of(context).pop(),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
