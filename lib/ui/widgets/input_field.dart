import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;
  final Function() onEditingComplete;
  final FocusNode focusNode;

  const InputField(
      {this.icon,
      this.hint,
      this.obscure,
      this.stream,
      this.onChanged,
      this.focusNode,
      this.onEditingComplete});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return TextField(
            focusNode: focusNode,
            onChanged: onChanged,
            decoration: InputDecoration(
              icon: Icon(
                icon,
              ),
              hintText: hint,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
              contentPadding:
                  EdgeInsets.only(left: 5, right: 30, bottom: 15, top: 15),
              errorText: snapshot.hasError ? snapshot.error : null,
            ),
            obscureText: obscure,
            onEditingComplete: onEditingComplete,
          );
        });
  }
}
