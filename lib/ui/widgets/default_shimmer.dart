import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DefaultShimmer extends StatelessWidget {
  const DefaultShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 200,
            height: 20,
            child: Shimmer.fromColors(
                child: Container(
                  color: Theme.of(context).primaryColor.withAlpha(50),
                  margin: EdgeInsets.symmetric(vertical: 4),
                ),
                baseColor: Theme.of(context).primaryColor,
                highlightColor: Colors.grey),
          ),
          SizedBox(
            width: 150,
            height: 20,
            child: Shimmer.fromColors(
                child: Container(
                  color: Theme.of(context).primaryColor.withAlpha(50),
                  margin: EdgeInsets.symmetric(vertical: 4),
                ),
                baseColor: Theme.of(context).primaryColor,
                highlightColor: Colors.grey),
          ),
          SizedBox(
            width: 200,
            height: 20,
            child: Shimmer.fromColors(
                child: Container(
                  color: Theme.of(context).primaryColor.withAlpha(50),
                  margin: EdgeInsets.symmetric(vertical: 4),
                ),
                baseColor: Theme.of(context).primaryColor,
                highlightColor: Colors.grey),
          ),
        ],
      ),
    );
  }
}
