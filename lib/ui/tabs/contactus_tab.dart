import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/ui/general/login_page.dart';
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
        actions: <Widget>[
          IconButton(
            tooltip: "Sair do App",
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              _logout(context);
            },
          ),
        ],

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

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Sair?"),
          content: new Text("Deseja realmente sair do aplicativo?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CANCELAR"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("SIM"),
              onPressed: () {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        );
      },
    );
  }
}
