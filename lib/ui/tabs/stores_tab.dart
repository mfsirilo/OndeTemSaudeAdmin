import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/blocs/store_list_bloc.dart';
import 'package:onde_tem_saude_admin/ui/tiles/store_tile.dart';
import 'package:onde_tem_saude_admin/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/no_record_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/search_field.dart';

class StoresTab extends StatelessWidget {
  StoresTab();

  @override
  Widget build(BuildContext context) {
    final _tableBloc = BlocProvider.of<StoreListBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Unidades de Saúde"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SearchField(onChanged: _tableBloc.onChangedSearch),
          Expanded(
            child: StreamBuilder<List>(
                stream: _tableBloc.outStores,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return LoadingWidget();
                  else if (snapshot.data.length == 0)
                    return NoRecordWidget();
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return StoreTile(snapshot.data[index]);
                        });
                }),
          )
        ],
      ),
    );
  }
}
