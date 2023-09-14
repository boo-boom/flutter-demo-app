import 'dart:math' as math;
import 'package:flutter/cupertino.dart';

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;
  final Widget child;

  StickyHeaderDelegate({required this.minHeight, required this.maxHeight, required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  double get maxExtent => math.max(maxHeight, minExtent);

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant StickyHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
