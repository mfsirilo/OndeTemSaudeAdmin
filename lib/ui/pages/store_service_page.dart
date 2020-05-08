import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/blocs/service_list_bloc.dart';
import 'package:onde_tem_saude_admin/ui/widgets/default_shimmer.dart';
import 'package:onde_tem_saude_admin/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/no_record_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/search_field.dart';

class StoreServicePage extends StatefulWidget {
  final DocumentSnapshot store;

  StoreServicePage({this.store});

  @override
  _StoreServicePageState createState() => _StoreServicePageState(store);
}

class _StoreServicePageState extends State<StoreServicePage> {
  _StoreServicePageState(DocumentSnapshot store);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _tableBloc = ServiceListBloc(store: widget.store);

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Especialidades"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SearchField(onChanged: _tableBloc.onChangedSearch),
          Expanded(
            child: StreamBuilder<List>(
                stream: _tableBloc.outService,
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
                                        .collection("services")
                                        .document(snapshot
                                            .data[index].reference.documentID)
                                        .setData({
                                      "uid": snapshot
                                          .data[index].reference.documentID
                                    });
                                    Firestore.instance
                                        .collection("store_service")
                                        .add({
                                      "store": widget.store.documentID,
                                      "service": snapshot
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
