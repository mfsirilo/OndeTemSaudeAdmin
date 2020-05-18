import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:onde_tem_saude_admin/controllers/store_bloc.dart';
import 'package:onde_tem_saude_admin/ui/widgets/images_widget.dart';

class StorePage extends StatefulWidget {
  final DocumentSnapshot store;

  StorePage({this.store});

  @override
  _StorePageState createState() => _StorePageState(store);
}

class _StorePageState extends State<StorePage> {
  final StoreBloc _storeBloc;
  var selectedCity, selectedDistrict;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _phone1Controller = MaskedTextController(mask: '(00) 0 0000-0000');
  final _phone2Controller = MaskedTextController(mask: '(00) 0 0000-0000');
  final _cepController = MaskedTextController(mask: '00.000-000');

  _StorePageState(DocumentSnapshot store)
      : _storeBloc = StoreBloc(store: store);

  void _onChanged1(bool value) => setState(() => _storeBloc.saveActive(value));

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
            stream: _storeBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data
                  ? "Editar Unidade de Saúde"
                  : "Criar Unidade de Saúde");
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _storeBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data)
                return StreamBuilder<bool>(
                    stream: _storeBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: snapshot.data
                            ? null
                            : () {
                                _deleteStore(context);
                              },
                      );
                    });
              else
                return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _storeBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : saveStore,
                );
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: _storeBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  selectedCity = snapshot.data["city"];
                  selectedDistrict = snapshot.data["district"];
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
                            "Ativa?",
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
                        height: 8,
                      ),
                      Text(
                        "Imagens",
                        style: TextStyle(fontSize: 12),
                      ),
                      ImagesWidget(
                        context: context,
                        initialValue: snapshot.data["images"],
                        onSaved: _storeBloc.saveImages,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["title"],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Título"),
                        onSaved: _storeBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["description"],
                        style: _fieldStyle,
                        maxLines: 2,
                        decoration: _buildDecoration("Descrição"),
                        onSaved: _storeBloc.saveDescription,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: TextFormField(
                                controller: _phone1Controller,
                                style: _fieldStyle,
                                decoration: _buildDecoration("Telefone 1"),
                                onSaved: _storeBloc.savePhone1,
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
                                onSaved: _storeBloc.savePhone2,
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
                        decoration: _buildDecoration("Endereço"),
                        onSaved: _storeBloc.saveAddress,
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
                                              _storeBloc
                                                  .saveCity(currencyValue);
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
                                                  _storeBloc.saveDistrict(
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
                                onSaved: _storeBloc.saveCep,
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
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: TextFormField(
                                initialValue:
                                    snapshot.data["latitude"].toString(),
                                style: _fieldStyle,
                                decoration: _buildDecoration("Latitude"),
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  _storeBloc.saveLatitude(double.parse(value));
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: TextFormField(
                                initialValue:
                                    snapshot.data["longitude"].toString(),
                                style: _fieldStyle,
                                decoration: _buildDecoration("Longitude"),
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  _storeBloc.saveLongitude(double.parse(value));
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _storeBloc.outLoading,
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

  void _deleteStore(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Deletar?"),
          content: new Text("Deseja realmente deletar esta Unidade de Saúde?"),
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
                _storeBloc.deleteStore();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String validateImages(List images) {
    if (images.isEmpty) return "Adicione imagens da Unidade de Saúde.";
    return null;
  }

  String validateTitle(String text) {
    if (text.isEmpty) return "Preencha o nome da Unidade de Saúde.";
    return null;
  }

  String validateAddress(String text) {
    if (text.isEmpty) return "Preencha o endereço da Unidade de Saúde.";
    return null;
  }

  String validatePhone(String text) {
    if (text.isEmpty) return "Preencha o telefone da Unidade de Saúde.";
    return null;
  }

  String validateLatitude(String text) {
    if (text.isEmpty) return "Preencha a Latitude da Unidade de Saúde.";
    return null;
  }

  String validateLongitude(String text) {
    if (text.isEmpty) return "Preencha a Longitude da Unidade de Saúde.";
    return null;
  }

  void saveStore() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Salvando Unidade de Saúde...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Theme.of(context).primaryColor,
      ));

      bool success = await _storeBloc.saveStore();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          success ? "Empresa salva!" : "Erro ao salvar a Unidade de Saúde!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ));

      if (success) Navigator.of(context).pop();
    }
  }
}
