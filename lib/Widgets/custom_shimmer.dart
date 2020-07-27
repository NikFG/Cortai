import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'custom_list_tile.dart';
class CustomShimmer extends StatelessWidget {
  final int itemCount;
  CustomShimmer(this.itemCount);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
              child: CustomListTile(
                leading: null,
                title: null,
                onTap: () {},
              ),
              baseColor: Colors.grey[300],
              highlightColor: Colors.white);
        });
  }
}
