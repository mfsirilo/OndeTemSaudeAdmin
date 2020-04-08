import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/blocs/service_bloc.dart';

class ServicePage extends StatefulWidget {
  final DocumentSnapshot service;

  ServicePage({this.service});

  @override
  _ServicePageState createState() => _ServicePageState(service);
}

class _ServicePageState extends State<ServicePage> {
  final ServiceBloc _serviceBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ServicePageState(DocumentSnapshot service)
      : _serviceBloc = ServiceBloc(register: service);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _fieldStyle = TextStyle(fontSize: 16);

    InputDecoration _buildDecoration(String label) {
      return InputDecoration(labelText: label);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _serviceBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(snapshot.data ? "Editar Serviço" : "Criar Serviço"),
                ],
              );
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _serviceBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data)
                return StreamBuilder<bool>(
                    stream: _serviceBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: snapshot.data
                            ? null
                            : () {
                                _delete(context);
                              },
                      );
                    });
              else
                return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _serviceBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : save,
                );
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: _serviceBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      TextFormField(
                        initialValue: snapshot.data["name"],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Nome*"),
                        onSaved: _serviceBloc.saveName,
                        validator: validateTitle,
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _serviceBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }

  void _delete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Deletar?"),
          content: new Text("Deseja realmente deletar este serviço?"),
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
                _serviceBloc.delete();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String validateTitle(String text) {
    if (text.isEmpty) return "Preencha o Nome do Serviço.";
    return null;
  }

  void save() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Salvando serviço...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Theme.of(context).primaryColor,
      ));

      bool success = await _serviceBloc.save();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          success ? "Serviço criado com sucesso!" : "Erro ao salvar o serviço!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ));

      if (success) Navigator.of(context).pop();
    }
  }
}
