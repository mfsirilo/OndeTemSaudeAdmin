import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/ui/views/district_page.dart';
import 'package:onde_tem_saude_admin/ui/widgets/active_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/default_shimmer.dart';

class DistrictTile extends StatelessWidget {
  final DocumentSnapshot document;

  DistrictTile(this.document);

  @override
  Widget build(BuildContext context) {
    if (document["name"].toString().isNotEmpty)
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DistrictPage(
                          district: document,
                        )));
              },
              contentPadding: EdgeInsets.only(left: 16.0, right: 8.0),
              title: Text(
                "${document["name"]}",
                style: TextStyle(
                    color: Colors.grey[850], fontWeight: FontWeight.w500),
              ),
              trailing: ActiveWidget(document["active"], true)),
        ),
      );
    else
      return DefaultShimmer();
  }
}
