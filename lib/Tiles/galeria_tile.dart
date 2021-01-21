import 'dart:convert';

import 'package:cortai/Dados/galeria.dart';
import 'package:cortai/Telas/galeria_detalhes_tela.dart';
import 'package:flutter/material.dart';

class GaleriaTile extends StatelessWidget {
  final Galeria galeria;

  const GaleriaTile(this.galeria);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesGaleria(galeria),
          ),
        );
      },
      child: Hero(
        tag: 'logo${galeria.id.toString()}',
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(base64Decode(galeria.imagem)),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
