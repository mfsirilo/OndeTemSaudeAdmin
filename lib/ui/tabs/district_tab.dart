import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/blocs/district_list_bloc.dart';
import 'package:onde_tem_saude_admin/ui/pages/district_page.dart';
import 'package:onde_tem_saude_admin/ui/tiles/district_tile.dart';
import 'package:onde_tem_saude_admin/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/no_record_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/search_field.dart';

class DistrictTab extends StatefulWidget {
  final DocumentSnapshot city;

  DistrictTab({this.city});

  @override
  _DistrictTabState createState() => _DistrictTabState();
}

class _DistrictTabState extends State<DistrictTab> {
  @override
  Widget build(BuildContext context) {
    final _tableBloc = DistrictListBloc(city: widget.city);

    return Scaffold(
      appBar: AppBar(
        title: Text("Bairros"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => DistrictPage(
                    city: widget.city,
                  ));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          SearchField(onChanged: _tableBloc.onChangedSearch),
          Expanded(
            child: StreamBuilder<List>(
                stream: _tableBloc.outDistrict,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return LoadingWidget();
                  else if (snapshot.data.length == 0)
                    return NoRecordWidget();
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return DistrictTile(snapshot.data[index]);
                        });
                }),
          )
        ],
      ),
    );
  }
}
