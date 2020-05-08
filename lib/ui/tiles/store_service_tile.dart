import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/ui/widgets/default_shimmer.dart';

class StoreServiceTile extends StatelessWidget {
  final DocumentSnapshot document;
  final DocumentSnapshot store;

  StoreServiceTile(this.document, this.store);

  @override
  Widget build(BuildContext context) {
    if (document["uid"].toString().isNotEmpty)
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          child: ListTile(
            onTap: document == null
                ? null
                : () {
                    _delete(context);
                  },
            contentPadding: EdgeInsets.only(left: 16.0, right: 8.0),
            title: FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection("services")
                  .document(document["uid"])
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  return Text(
                    "${snapshot.data["name"]}",
                    style: TextStyle(
                        color: Colors.grey[850], fontWeight: FontWeight.w500),
                  );
                }
              },
            ),
          ),
        ),
      );
    else
      return DefaultShimmer();
  }

  void _delete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Deletar?"),
          content: new Text("Deseja realmente desvincular este item?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CANCELAR"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("SIM"),
              onPressed: () {
                document.reference.delete();
                Firestore.instance
                    .collection("store_service")
                    .where(
                      "service",
                      isEqualTo: document.documentID,
                    )
                    .where("store", isEqualTo: store.documentID)
                    .getDocuments()
                    .then((values) {
                  for (DocumentSnapshot doc in values.documents) {
                    doc.reference.delete();
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
