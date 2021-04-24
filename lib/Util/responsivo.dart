import 'package:flutter/material.dart';

class Responsivo {
  static MediaQueryData? tamanhoTela;
  late double telaWidth;
  late double telaHeight;
  late double blockSizeHorizontal;
  late double textResponsivo;

  void init(BuildContext context) {
    tamanhoTela = MediaQuery.of(context);
    telaWidth = tamanhoTela!.size.width;
    telaHeight = tamanhoTela!.size.height;
    blockSizeHorizontal = telaWidth / 100;
    // 720 por ser a média de altura das telas
    textResponsivo = telaHeight / 720;
  }
}
