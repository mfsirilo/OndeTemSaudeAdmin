import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  final DocumentSnapshot message;

  ContactUsPage(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes da Mensagem"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        children: <Widget>[
          message["name"].toString().isEmpty &&
                  message["email"].toString().isEmpty &&
                  message["phone"].toString().isEmpty
              ? Container()
              : Card(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Contato",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                        Divider(),
                        SizedBox(
                          height: 10.0,
                        ),
                        message["name"] == null ||
                                message["name"].toString().isEmpty
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("Nome: ",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("${message["name"]}",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      )),
                                ],
                              ),
                        SizedBox(
                          height: 4.0,
                        ),
                        message["email"] == null ||
                                message["email"].toString().isEmpty
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("E-mail: ",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("${message["email"]}",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      )),
                                ],
                              ),
                        SizedBox(
                          height: 4.0,
                        ),
                        message["phone"] == null ||
                                message["phone"].toString().isEmpty
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("Telefone: ",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("${message["phone"]}",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      )),
                                ],
                              ),
                      ],
                    ),
                  )),
          Card(
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Mensagem",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w500),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text("${message["message"]}",
                        style: TextStyle(
                          fontSize: 16.0,
                        )),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
