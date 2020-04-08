import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/blocs/service_list_bloc.dart';
import 'package:onde_tem_saude_admin/ui/tiles/service_tile.dart';
import 'package:onde_tem_saude_admin/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/no_record_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/search_field.dart';

class ServicesTab extends StatefulWidget {
  @override
  _ServicesTabState createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTab> {
  @override
  Widget build(BuildContext context) {
    final _tableBloc = BlocProvider.of<ServiceListBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Serviços"),
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
                    return NoRecordWidget();
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return ServiceTile(snapshot.data[index]);
                        });
                }),
          )
        ],
      ),
    );
  }
}
