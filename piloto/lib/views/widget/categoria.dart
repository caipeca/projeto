import 'package:flutter/material.dart';

class Categoria extends StatelessWidget {
  const Categoria({super.key, required this.categoria, this.border});
  final String categoria;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 150,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: border,
          color: Colors.teal.shade900,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          categoria,
          style: TextStyle(fontSize: 14),
          softWrap: true,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
