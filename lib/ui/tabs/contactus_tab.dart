import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/ui/tiles/contact_tile.dart';
import 'package:onde_tem_saude_admin/blocs/contactus_bloc.dart';
import 'package:onde_tem_saude_admin/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/no_record_widget.dart';

class ContactUsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _contactUsBloc = BlocProvider.of<ContactUsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Mensagens"),
        centerTitle: true,
      ),
      body: StreamBuilder<List>(
          stream: _contactUsBloc.outContactUs,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return LoadingWidget();
            else if (snapshot.data.length == 0)
              return NoRecordWidget();
            else
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ContactUsTile(snapshot.data[index]);
                  });
          }),
    );
  }
}
