import 'package:flutter/material.dart';

class TextWidgetHeader extends SliverPersistentHeaderDelegate {


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container();
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 50;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
    // TODO: implement shouldRebuild


}
