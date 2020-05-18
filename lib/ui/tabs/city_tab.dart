import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onde_tem_saude_admin/controllers/city_list_bloc.dart';
import 'package:onde_tem_saude_admin/ui/tiles/city_tile.dart';
import 'package:onde_tem_saude_admin/ui/widgets/loading_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/no_record_widget.dart';
import 'package:onde_tem_saude_admin/ui/widgets/search_field.dart';
import 'package:onde_tem_saude_admin/ui/general/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';

class CityTab extends StatefulWidget {
  @override
  _CityTabState createState() => _CityTabState();
}

class _CityTabState extends State<CityTab> {
  @override
  Widget build(BuildContext context) {
    final _tableBloc = BlocProvider.of<CityListBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cidades"),
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
                stream: _tableBloc.outCities,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return LoadingWidget();
                  else if (snapshot.data.length == 0)
                    return NoRecordWidget();
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return CityTile(snapshot.data[index]);
                        });
                }),
          )
        ],
      ),
    );
  }

  _generatePdfAndView(context, CityListBloc tableBloc) async {
    var users = await tableBloc.getCities();
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
                              pdfLib.Text('Lista de Cidades',
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
