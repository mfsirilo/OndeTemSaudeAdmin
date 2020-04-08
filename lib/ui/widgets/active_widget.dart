import 'package:flutter/material.dart';

class ActiveWidget extends StatelessWidget {
  final bool active;
  final bool male;

  const ActiveWidget(this.active, this.male);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
            "${active ? "ATIV${male ? "O" : "A"}" : "INATIV${male ? "O" : "A"}"}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active ? Theme.of(context).primaryColor : Colors.red),
          ),
        ),
      ],
    );
  }
}
