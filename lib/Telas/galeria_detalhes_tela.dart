import 'dart:convert';
import 'dart:io';

import 'package:cortai/Dados/galeria.dart';
import 'package:cortai/Util/share_redes_sociais.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class DetalhesGaleria extends StatelessWidget {
  final Galeria galeria;

  DetalhesGaleria(this.galeria);

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(galeria.salao.nome!),
        leading: Util.leadingScaffold(context),
        actions: [
          IconButton(
            onPressed: () async {
              Directory tempDir = await getTemporaryDirectory();
              String tempPath = tempDir.path;
              final decodedBytes = base64Decode(galeria.imagem);
              var file = File(tempPath + '/temp.png');
              file.writeAsBytesSync(decodedBytes);
              ShareRedesSociais().compartilharGeral(file,
                  comentario:
                      "Corte feito no Cortaí por ${galeria.cabeleireiro.nome}");
            },
            icon: Icon(Icons.share_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: deviceInfo.size.height / 1.2,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: deviceInfo.size.height * 3 / 10,
                  width: MediaQuery.of(context).size.width,
                  child: PhotoView(
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.contained * 1.8,
                    backgroundDecoration: BoxDecoration(color: Colors.black12),
                    imageProvider: MemoryImage(base64Decode(galeria.imagem)),
                    initialScale: PhotoViewComputedScale.contained,
                    basePosition: Alignment.center,
                  ),
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          deviceInfo.size.height * 1 / 100,
                          deviceInfo.size.height * 1 / 100,
                          0,
                          0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            galeria.servico.descricao!,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'R\$${galeria.servico.valor.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: deviceInfo.size.height * 2 / 100,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Text(
                              galeria.descricao,
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          Container(height: deviceInfo.size.height * 2 / 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
