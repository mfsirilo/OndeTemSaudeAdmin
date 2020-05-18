import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/controllers/store_district_list_bloc.dart';
import 'package:onde_tem_saude_admin/ui/views/store_district_page.dart';
import 'package:onde_tem_saude_admin/ui/tiles/store_district_tile.dart';
import 'package:onde_tem_saude_admin/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/no_record_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/search_field.dart';

class StoreDistrictTab extends StatefulWidget {
  final DocumentSnapshot store;

  StoreDistrictTab({this.store});

  @override
  _StoreDistrictTabState createState() => _StoreDistrictTabState();
}

class _StoreDistrictTabState extends State<StoreDistrictTab> {
  @override
  Widget build(BuildContext context) {
    final _tableBloc = StoreDistrictListBloc(store: widget.store);

    return Scaffold(
      appBar: AppBar(
        title: Text("Vincular Bairros"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => StoreDistrictPage(
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
                stream: _tableBloc.outStoreDistrict,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return LoadingWidget();
                  else if (snapshot.data.length == 0)
                    return NoRecordWidget();
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return StoreDistrictTile(
                              snapshot.data[index], widget.store);
                        });
                }),
          )
        ],
      ),
    );
  }
}
