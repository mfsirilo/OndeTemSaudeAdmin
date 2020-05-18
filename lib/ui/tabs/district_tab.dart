import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onde_tem_saude_admin/controllers/district_list_bloc.dart';
import 'package:onde_tem_saude_admin/ui/views/district_page.dart';
import 'package:onde_tem_saude_admin/ui/tiles/district_tile.dart';
import 'package:onde_tem_saude_admin/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/no_record_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/search_field.dart';
import 'package:onde_tem_saude_admin/ui/general/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';

class DistrictTab extends StatefulWidget {
  final DocumentSnapshot city;

  DistrictTab({this.city});

  @override
  _DistrictTabState createState() => _DistrictTabState();
}

class _DistrictTabState extends State<DistrictTab> {
  @override
  Widget build(BuildContext context) {
    final _tableBloc = DistrictListBloc(city: widget.city);

    return Scaffold(
      appBar: AppBar(
        title: Text("Bairros"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => DistrictPage(
                    city: widget.city,
                  ));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          SearchField(onChanged: _tableBloc.onChangedSearch),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "CIDADE: " + widget.city["name"],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<List>(
                stream: _tableBloc.outDistrict,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return LoadingWidget();
                  else if (snapshot.data.length == 0)
                    return NoRecordWidget();
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return DistrictTile(snapshot.data[index]);
                        });
                }),
          )
        ],
      ),
    );
  }

  _generatePdfAndView(context, DistrictListBloc tableBloc) async {
    var users = await tableBloc.getDistricts();
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
                              pdfLib.Text(
                                  'Lista de Bairros de ' +
                                      widget.city["name"] +
                                      ".",
                                  textScaleFactor: 1.5),
                              pdfLib.Text('Data: $data.', textScaleFactor: 1),
                            ]),
                        pdfLib.Image(_logo)
                      ])),
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>["Nome"],
                ...users.map((item) {
                  return [
                    item.data["name"],
                  ];
                })
              ])
            ]));

//    final String dir = (await getApplicationDocumentsDirectory()).path;
//    final String path = '$dir/especialidades.pdf';
//    final File file = File(path);
//    file.writeAsBytesSync(pdf.save());

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
