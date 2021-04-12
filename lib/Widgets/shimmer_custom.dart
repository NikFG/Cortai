import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'list_tile_custom.dart';

class ShimmerCustom extends StatelessWidget {
  final int itemCount;

  ShimmerCustom(this.itemCount);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
              child: ListTileCustom(
                leading: null,
                title: null,
                onTap: () {},
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.white);
        });
  }
}
