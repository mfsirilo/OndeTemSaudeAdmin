import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/ui/views/user_page.dart';
import 'package:onde_tem_saude_admin/ui/widgets/active_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/default_shimmer.dart';

class UserTile extends StatelessWidget {
  final DocumentSnapshot document;

  const UserTile(this.document);

  @override
  Widget build(BuildContext context) {
    if (document["name"].toString().isNotEmpty)
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          child: ListTile(
            onTap: () async {
              await Firestore.instance
                  .collection("cities")
                  .document(document.data["city"])
                  .collection("districts")
                  .document(document.data["district"])
                  .get()
                  .then((value) {
                if (value.data == null) document.data["district"] = null;
              });

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserPage(
                        user: document,
                      )));
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            title: Text(
              document["name"],
              style: TextStyle(
                  color: Colors.grey[850], fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              document["email"],
            ),
            trailing: ActiveWidget(document["active"], true),
          ),
        ),
      );
    else
      return DefaultShimmer();
  }
}
