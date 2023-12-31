import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

void ShimmerPage(double width, double height) {
  Shimmer.fromColors(
    baseColor: Colors.grey[500]!,
    highlightColor: Colors.grey[300]!,
    period: Duration(seconds: 2),
    child: Container(
        width: width == 0 ? double.infinity : width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.grey[400]!, borderRadius: BorderRadius.circular(14))),
  );
}
