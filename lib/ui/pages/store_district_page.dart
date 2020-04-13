import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/blocs/district_list_bloc.dart';
import 'package:onde_tem_saude_admin/ui/widgets/default_shimmer.dart';
import 'package:onde_tem_saude_admin/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/no_record_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/search_field.dart';

class StoreDistrictPage extends StatefulWidget {
  final DocumentSnapshot store;

  StoreDistrictPage({this.store});

  @override
  _StoreDistrictPageState createState() => _StoreDistrictPageState(store);
}

class _StoreDistrictPageState extends State<StoreDistrictPage> {
  _StoreDistrictPageState(DocumentSnapshot store);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _tableBloc = DistrictListBloc(store: widget.store);

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Bairros"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SearchField(onChanged: _tableBloc.onChangedSearch),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text(
                  "CIDADE: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                FutureBuilder<DocumentSnapshot>(
                  future: Firestore.instance
                      .collection("cities")
                      .document(widget.store.data["city"])
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
                            color: Colors.grey[850],
                            fontWeight: FontWeight.w500),
                      );
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List>(
                stream: _tableBloc.outDistrict,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return LoadingWidget();
                  else if (snapshot.data.length == 0)
                    return NoRecordWidget(msg: "Todos os itens já vinculados.");
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data[index]["name"]
                              .toString()
                              .isNotEmpty)
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    widget.store.reference
                                        .collection("districts")
                                        .document(snapshot
                                            .data[index].reference.documentID)
                                        .setData({
                                      "uid": snapshot
                                          .data[index].reference.documentID
                                    });
                                    Firestore.instance
                                        .collection("store_district")
                                        .add({
                                      "store": widget.store.documentID,
                                      "district": snapshot
                                          .data[index].reference.documentID
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  contentPadding:
                                      EdgeInsets.only(left: 16.0, right: 8.0),
                                  title: Text(
                                    "${snapshot.data[index]["name"]}",
                                    style: TextStyle(
                                        color: Colors.grey[850],
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            );
                          else
                            return DefaultShimmer();
                        });
                }),
          )
        ],
      ),
    );
  }
}
