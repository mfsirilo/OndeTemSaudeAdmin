import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onde_tem_saude_admin/ui/views/contactus_page.dart';
import 'package:onde_tem_saude_admin/ui/widgets/default_shimmer.dart';

class ContactUsTile extends StatelessWidget {
  final DocumentSnapshot document;

  ContactUsTile(this.document);

  @override
  Widget build(BuildContext context) {
    if (document["message"].toString().isNotEmpty)
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ContactUsPage(document)));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${DateFormat('dd-MM-yyyy – kk:mm').format(document["date"].toDate())}: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "${document["message"]}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ));
    else
      return DefaultShimmer();
  }
}
