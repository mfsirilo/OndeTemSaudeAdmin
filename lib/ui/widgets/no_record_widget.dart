import 'package:flutter/material.dart';

class NoRecordWidget extends StatelessWidget {
  const NoRecordWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.grid_off,
            size: 80.0,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            "Nenhum registro encontrado!",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
