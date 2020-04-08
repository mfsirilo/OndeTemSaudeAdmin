import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final Function(String) onChanged;

  const SearchField({this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          decoration: InputDecoration(
              hintText: "Pesquisar",
              icon: Icon(
                Icons.search,
              ),
              border: InputBorder.none),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
