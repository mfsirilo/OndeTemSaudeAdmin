import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onde_tem_saude_admin/controllers/user_list_bloc.dart';
import 'package:onde_tem_saude_admin/ui/tiles/user_tile.dart';
import 'package:onde_tem_saude_admin/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/no_record_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/search_field.dart';
import 'package:onde_tem_saude_admin/ui/general/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _tableBloc = BlocProvider.of<UserListBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Usuários"),
        centerTitle: true,
        leading: IconButton(
          tooltip: "Sair do App",
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          onPressed: () {
            _logout(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            tooltip: "Gerar PDF",
            icon: Icon(
              Icons.picture_as_pdf,
              color: Colors.white,
            ),
            onPressed: () => _generatePdfAndView(context, _tableBloc),
          )
        ],
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

  _generatePdfAndView(context, UserListBloc tableBloc) async {
    var users = await tableBloc.getUsers();
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    PdfImage _logo = PdfImage.file(
      pdf.document,
      bytes: (await rootBundle.load('images/logo_72.png')).buffer.asUint8List(),
    );

    String data =
        formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);

    pdf.addPage(pdfLib.MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
        build: (context) => [
              pdfLib.Header(
                  level: 0,
                  child: pdfLib.Row(
                      mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                      children: <pdfLib.Widget>[
                        pdfLib.Column(
                            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                            children: <pdfLib.Widget>[
                              pdfLib.Text('Onde tem Saúde', textScaleFactor: 2),
                              pdfLib.Text('Lista de Usuários',
                                  textScaleFactor: 1.5),
                              pdfLib.Text('Data: $data.', textScaleFactor: 1),
                            ]),
                        pdfLib.Image(_logo)
                      ])),
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>["Nome", "E-mail", "Telefone", "Endereço"],
                ...users.map((item) {
                  String endereco = "";
                  if (item.data['address'].toString().isNotEmpty)
                    endereco = item.data['address'];
                  if (item.data['bairro'].toString().isNotEmpty)
                    endereco += item.data['bairro'].toString();
                  if (item.data['cidade'].toString().isNotEmpty)
                    endereco += item.data['cidade'].toString();

                  return [
                    item.data["name"],
                    item.data["email"],
                    item.data["phone1"],
                    endereco + " - GO"
                  ];
                })
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/users.pdf';
    final File file = File(path);
    file.writeAsBytesSync(pdf.save());

    Printing.layoutPdf(
      onLayout: (pageFormat) {
        return pdf.save();
      },
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
