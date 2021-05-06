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
        child: Image.memory(
          base64Decode(galeria.imagem!),
          width: 100,
          height: 100,
          cacheHeight: 75,
          cacheWidth: 75,
          scale: 0.75,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
