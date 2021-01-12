import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:photo_view/photo_view.dart';

class HeroCustom extends StatelessWidget {
  final File imagemFile;
  final String descricao;
  final String imagemMemory;
  HeroCustom({this.imagemFile, this.descricao,this.imagemMemory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: Util.leadingScaffold(context),
        backgroundColor: Colors.transparent,
        title: descricao != null
            ? Text(
                this.descricao,
                style: TextStyle(fontWeight: FontWeight.w600),
              )
            : Container(
                height: 0,
                width: 0,
              ),
        centerTitle: true,
      ),
      body: Center(
        child: PhotoView(
          minScale: PhotoViewComputedScale.contained,
          heroAttributes: PhotoViewHeroAttributes(
            tag: 'Foto',
            transitionOnUserGestures: true,
          ),
          imageProvider: this.imagemFile == null
              ? MemoryImage(
                  base64Decode(this.imagemMemory),
                )
              : FileImage(this.imagemFile),
        ),
      ),
    );
  }
}
