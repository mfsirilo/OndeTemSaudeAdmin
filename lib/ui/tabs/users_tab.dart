import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/blocs/user_list_bloc.dart';
import 'package:onde_tem_saude_admin/ui/tiles/user_tile.dart';
import 'package:onde_tem_saude_admin/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/no_record_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/search_field.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _tableBloc = BlocProvider.of<UserListBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Usuários"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SearchField(onChanged: _tableBloc.onChangedSearch),
          Expanded(
            child: StreamBuilder<List>(
                stream: _tableBloc.outUsers,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return LoadingWidget();
                  else if (snapshot.data.length == 0)
                    return NoRecordWidget();
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return UserTile(snapshot.data[index]);
                        });
                }),
          )
        ],
      ),
    );
  }
}
