import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer(
      {super.key,
      required this.width,
      required this.height,
      required this.radius});

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xfff2f2f2).withValues(alpha: .8),
      highlightColor: const Color(0xffe4e4e4).withValues(alpha: 0),
      direction: ShimmerDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius), color: Colors.white),
        width: width,
        height: height,
      ),
    );
  }
}
