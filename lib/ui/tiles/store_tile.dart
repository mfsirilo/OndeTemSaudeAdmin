import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/ui/tabs/store_district_tab.dart';
import 'package:onde_tem_saude_admin/ui/tabs/store_service_tab.dart';
import 'package:onde_tem_saude_admin/ui/tabs/store_specialty_tab.dart';
import 'package:onde_tem_saude_admin/ui/widgets/active_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/default_shimmer.dart';
import 'package:onde_tem_saude_admin/ui/pages/store_page.dart';

class StoreTile extends StatelessWidget {
  final DocumentSnapshot document;

  StoreTile(this.document);

  @override
  Widget build(BuildContext context) {
    if (document["title"].toString().isNotEmpty)
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          child: ListTile(
            onTap: () {
              _showOptions(context);
            },
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            //leading: CircleAvatar(
            //  backgroundImage: NetworkImage(document["images"][0]),
            //  backgroundColor: Colors.transparent,
            //),
            title: Text(
              document["title"],
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

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildRow("Editar", () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StorePage(
                                store: document,
                              )));
                    }),
                    buildRow("Adicionar Bairros Relacionados", () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StoreDistrictTab(
                                store: document,
                              )));
                    }),
                    buildRow("Adicionar Especialidades", () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StoreSpecialtyTab(
                                store: document,
                              )));
                    }),
                    buildRow("Adicionar Serviços", () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StoreServiceTab(
                                store: document,
                              )));
                    })
                  ],
                ),
              );
            },
          );
        });
  }

  Row buildRow(String text, Function function) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            onPressed: function,
          ),
        ),
      ],
    );
  }
}
