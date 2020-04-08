import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/blocs/district_bloc.dart';

class DistrictPage extends StatefulWidget {
  final DocumentSnapshot district;
  final DocumentSnapshot city;

  DistrictPage({this.city, this.district});

  @override
  _DistrictPageState createState() => _DistrictPageState(city, district);
}

class _DistrictPageState extends State<DistrictPage> {
  final DistrictBloc _districtBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _DistrictPageState(DocumentSnapshot city, DocumentSnapshot district)
      : _districtBloc = DistrictBloc(city: city, register: district);

  void _onChanged1(bool value) => setState(() => _districtBloc.saveActive(value));

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
            stream: _districtBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(snapshot.data ? "Editar Bairro" : "Criar Bairro"),
                ],
              );
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _districtBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data)
                return StreamBuilder<bool>(
                    stream: _districtBloc.outLoading,
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
              stream: _districtBloc.outLoading,
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
                stream: _districtBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Ativo?",
                            style: TextStyle(
                                color: Colors.grey[650],
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          new Switch(
                              value: snapshot.data["active"],
                              onChanged: _onChanged1),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["name"],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Nome*"),
                        onSaved: _districtBloc.saveName,
                        validator: validateTitle,
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _districtBloc.outLoading,
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
          content: new Text("Deseja realmente deletar este bairro?"),
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
                _districtBloc.delete();
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
    if (text.isEmpty) return "Preencha o Nome da Bairro.";
    return null;
  }

  void save() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Salvando bairro...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Theme.of(context).primaryColor,
      ));

      bool success = await _districtBloc.save();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          success ? "Bairro criado com sucesso!" : "Erro ao salvar a bairro!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ));

      if (success) Navigator.of(context).pop();
    }
  }
}
