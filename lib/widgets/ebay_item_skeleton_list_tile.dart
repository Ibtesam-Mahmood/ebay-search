
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

///Skeleton viewer for user tile
class SkeletonEbayItemListTile extends StatelessWidget {

  static Widget skeletonBuilder(BuildContext context, [int count = 9]){

    return Column(
      children: [
        for (var i = 0; i < count; i++)
          const SkeletonEbayItemListTile()
      ],
    );

  }

  final bool isTop;
  final bool isBottom;

  const SkeletonEbayItemListTile({ Key? key, this.isTop = false, this.isBottom = false}) : super(key: key);

  Widget fractionalBar(BuildContext context, double scale){
    assert(scale >= 0.0 && scale <= 1.0);

    return FractionallySizedBox(
      widthFactor: scale,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> children = [

      Container(
        width: 75,
        height: 75,
        color: Colors.white,
      ),

      Container(width: 8),

      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 10),
            fractionalBar(context, 0.8),
            Container(height: 20),
            fractionalBar(context, 0.3),
          ],
        ),
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[300]!,
        direction: ShimmerDirection.ltr,
        enabled: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children
        ),
      ),
    );
  }
}