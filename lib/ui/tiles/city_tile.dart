import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/ui/tabs/district_tab.dart';
import 'package:onde_tem_saude_admin/ui/widgets/active_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/default_shimmer.dart';
import 'package:onde_tem_saude_admin/ui/pages/city_page.dart';

class CityTile extends StatelessWidget {
  final DocumentSnapshot document;

  CityTile(this.document);

  @override
  Widget build(BuildContext context) {
    if (document["name"].toString().isNotEmpty)
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Card(
          child: ListTile(
            onLongPress: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CityPage(
                        city: document,
                      )));
            },
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DistrictTab(
                        city: document,
                      )));
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            title: Text(
              "${document["name"]}",
              style: TextStyle(
                  color: Colors.grey[850], fontWeight: FontWeight.w500),
            ),
            trailing: ActiveWidget(document["active"], false),
          ),
        ),
      );
    else
      return DefaultShimmer();
  }
}
