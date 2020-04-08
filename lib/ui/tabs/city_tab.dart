import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/blocs/city_list_bloc.dart';
import 'package:onde_tem_saude_admin/ui/tiles/city_tile.dart';
import 'package:onde_tem_saude_admin/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/no_record_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/search_field.dart';

class CityTab extends StatefulWidget {
  @override
  _CityTabState createState() => _CityTabState();
}

class _CityTabState extends State<CityTab> {
  @override
  Widget build(BuildContext context) {
    final _tableBloc = BlocProvider.of<CityListBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cidades"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SearchField(onChanged: _tableBloc.onChangedSearch),
          Expanded(
            child: StreamBuilder<List>(
                stream: _tableBloc.outCities,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return LoadingWidget();
                  else if (snapshot.data.length == 0)
                    return NoRecordWidget();
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return CityTile(snapshot.data[index]);
                        });
                }),
          )
        ],
      ),
    );
  }
}
