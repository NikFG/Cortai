import 'package:agendacabelo/Util/util.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:photo_view/photo_view.dart';

class HeroCustom extends StatelessWidget {
  final String imagemUrl;
  final File imagemFile;

  HeroCustom({this.imagemUrl, this.imagemFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: Util.leadingScaffold(context),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: PhotoView(
          heroAttributes: PhotoViewHeroAttributes(
            tag: 'Foto',
            transitionOnUserGestures: true,
          ),
          imageProvider: this.imagemFile == null
              ? NetworkImage(this.imagemUrl)
              : FileImage(this.imagemFile),
        ),
      ),
    );
  }
}
