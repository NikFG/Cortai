import 'package:flutter/material.dart';
import 'dart:io';
class HeroCustom extends StatelessWidget {
  final String imagemUrl;
  final File imagemFile;

  HeroCustom({this.imagemUrl, this.imagemFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'Foto',
            child: this.imagemFile == null
                ? Image.network(this.imagemUrl)
                : Image.file(this.imagemFile),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
        onPanUpdate: (details) {
          if (details.delta.dx > 10) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}