import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/controllers/store_service_list_bloc.dart';
import 'package:onde_tem_saude_admin/ui/views/store_service_page.dart';
import 'package:onde_tem_saude_admin/ui/tiles/store_service_tile.dart';
import 'package:onde_tem_saude_admin/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/no_record_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/search_field.dart';

class StoreServiceTab extends StatefulWidget {
  final DocumentSnapshot store;

  StoreServiceTab({this.store});

  @override
  _StoreServiceTabState createState() => _StoreServiceTabState();
}

class _StoreServiceTabState extends State<StoreServiceTab> {
  @override
  Widget build(BuildContext context) {
    final _tableBloc = StoreServiceListBloc(store: widget.store);

    return Scaffold(
      appBar: AppBar(
        title: Text("Vincular Serviços"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => StoreServicePage(
                    store: widget.store,
                  ));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                widget.store["title"],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
          ),
          SearchField(onChanged: _tableBloc.onChangedSearch),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Text(
              "Itens vinculados:",
            ),
          ),
          Expanded(
            child: StreamBuilder<List>(
                stream: _tableBloc.outStoreService,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return LoadingWidget();
                  else if (snapshot.data.length == 0)
                    return NoRecordWidget();
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return StoreServiceTile(
                              snapshot.data[index], widget.store);
                        });
                }),
          )
        ],
      ),
    );
  }
}
