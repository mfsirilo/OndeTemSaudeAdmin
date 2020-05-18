import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:onde_tem_saude_admin/controllers/user_bloc.dart';

import '../../globals.dart';

class UserPage extends StatefulWidget {
  final DocumentSnapshot user;

  UserPage({this.user});

  @override
  _UserPageState createState() => _UserPageState(user);
}

class _UserPageState extends State<UserPage> {
  final UserBloc _userBloc;
  var selectedCity, selectedDistrict, selectedType;
  List<DropdownMenuItem> typeItems = [];

  final _phone1Controller = MaskedTextController(mask: '(00) 0 0000-0000');
  final _phone2Controller = MaskedTextController(mask: '(00) 0 0000-0000');
  final _cepController = MaskedTextController(mask: '00.000-000');

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _UserPageState(DocumentSnapshot user) : _userBloc = UserBloc(user: user);

  void _onChanged1(bool value) => setState(() => _userBloc.saveActive(value));

  @override
  Widget build(BuildContext context) {
    final _fieldStyle = TextStyle(fontSize: 16);

    typeItems = [];
    typeItems.add(buildDropdownMenuItem("user", "Munícipe"));
    typeItems.add(buildDropdownMenuItem("operator", "Operador"));
    if (isAdmin) typeItems.add(buildDropdownMenuItem("admin", "Administrador"));

    InputDecoration _buildDecoration(String label) {
      return InputDecoration(labelText: label);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _userBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data ? "Editar Usuário" : "Criar Usuário");
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _userBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data)
                return StreamBuilder<bool>(
                    stream: _userBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: snapshot.data
                            ? null
                            : () {
                                _deleteUser(context);
                              },
                      );
                    });
              else
                return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _userBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : saveUser,
                );
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: _userBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  selectedCity = snapshot.data["city"];
                  selectedDistrict = snapshot.data["district"];
                  selectedType = snapshot.data["type"];
                  _phone1Controller.text = snapshot.data["phone1"];
                  _phone2Controller.text = snapshot.data["phone2"];
                  _cepController.text = snapshot.data["cep"];

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 26.0),
                            child: Text(
                              "Tipo:",
                              style: TextStyle(
                                  color: Colors.grey[650],
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  DropdownButton(
                                    items: typeItems,
                                    onChanged: (currencyValue) {
                                      _userBloc.saveType(currencyValue);
                                      setState(() {
                                        selectedType = currencyValue;
                                      });
                                    },
                                    value: selectedType,
                                    isExpanded: true,
                                    hint: Text(
                                      "Selecione...",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["name"],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Nome: *"),
                        onSaved: _userBloc.saveName,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["email"],
                        style: _fieldStyle,
                        decoration: _buildDecoration("E-mail: *"),
                        onSaved: _userBloc.saveEmail,
                        validator: validateEmail,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: TextFormField(
                                controller: _phone1Controller,
                                style: _fieldStyle,
                                decoration: _buildDecoration("Telefone 1: *"),
                                onSaved: _userBloc.savePhone1,
                                keyboardType: TextInputType.number,
                                validator: validatePhone,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: TextFormField(
                                controller: _phone2Controller,
                                style: _fieldStyle,
                                decoration: _buildDecoration("Telefone 2"),
                                onSaved: _userBloc.savePhone2,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["address"],
                        style: _fieldStyle,
                        maxLines: 2,
                        decoration: _buildDecoration("Endereço: *"),
                        onSaved: _userBloc.saveAddress,
                        validator: validateAddress,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection("cities")
                                  .where("active", isEqualTo: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return const Text("Carregando...");
                                else {
                                  List<DropdownMenuItem> currencyItems = [];
                                  for (int i = 0;
                                      i < snapshot.data.documents.length;
                                      i++) {
                                    DocumentSnapshot snap =
                                        snapshot.data.documents[i];
                                    currencyItems.add(
                                      DropdownMenuItem(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: Text(
                                            snap["name"],
                                            style: TextStyle(
                                                color: Color(0xff11b719)),
                                          ),
                                        ),
                                        value: "${snap.documentID}",
                                      ),
                                    );
                                  }
                                  return Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Cidade:"),
                                          DropdownButton(
                                            items: currencyItems,
                                            onChanged: (currencyValue) {
                                              _userBloc.saveCity(currencyValue);
                                              setState(() {
                                                selectedCity = currencyValue;
                                              });
                                            },
                                            value: selectedCity,
                                            isExpanded: true,
                                            hint: Text(
                                              "Selecione...",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }),
                          selectedCity == null
                              ? Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Bairro:"),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Selecione a Cidade..."),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection("cities")
                                      .document(selectedCity)
                                      .collection("districts")
                                      .where("active", isEqualTo: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return const Text("Carregando...");
                                    else {
                                      List<DropdownMenuItem> currencyItems = [];
                                      for (int i = 0;
                                          i < snapshot.data.documents.length;
                                          i++) {
                                        DocumentSnapshot snap =
                                            snapshot.data.documents[i];
                                        currencyItems.add(
                                          DropdownMenuItem(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Text(
                                                snap["name"],
                                                style: TextStyle(
                                                    color: Color(0xff11b719)),
                                              ),
                                            ),
                                            value: "${snap.documentID}",
                                          ),
                                        );
                                      }
                                      return Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("Bairro:"),
                                              DropdownButton(
                                                items: currencyItems,
                                                onChanged: (currencyValue) {
                                                  _userBloc.saveDistrict(
                                                      currencyValue);
                                                  setState(() {
                                                    selectedDistrict =
                                                        currencyValue;
                                                  });
                                                },
                                                value: selectedDistrict,
                                                isExpanded: true,
                                                hint: Text(
                                                  "Selecione...",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: TextFormField(
                                controller: _cepController,
                                style: _fieldStyle,
                                decoration: _buildDecoration("CEP"),
                                onSaved: _userBloc.saveCep,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.only(left: 6.0, top: 25.0),
                            child: Center(
                              child: Text(
                                "Goiás - Brasil",
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _userBloc.outLoading,
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

  DropdownMenuItem buildDropdownMenuItem(String key, String value) {
    return DropdownMenuItem(
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Text(
          value,
          style: TextStyle(color: Color(0xff11b719)),
        ),
      ),
      value: key,
    );
  }

  void _deleteUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Deletar?"),
          content: new Text("Deseja realmente deletar este Usuário?"),
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
                _userBloc.deleteUser();
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
    if (text.isEmpty) return "Preencha o nome do Usuário.";
    return null;
  }

  String validateEmail(String text) {
    if (text.isEmpty) return "Preencha o email do Usuário.";
    if (!text.contains("@") || !text.contains(".")) return "E-mail inválido!";
    return null;
  }

  String validateAddress(String text) {
    if (text.isEmpty) return "Preencha o endereço do Usuário.";
    return null;
  }

  String validatePhone(String text) {
    if (text.isEmpty) return "Preencha o telefone do Usuário.";
    return null;
  }

  void saveUser() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Salvando usuário...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Theme.of(context).primaryColor,
      ));

      bool success = await _userBloc.saveUser();
      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          success ? "Usuário salvo!" : "Erro ao salvar o usuário!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ));

      if (success) Navigator.of(context).pop();
    }
  }
}
