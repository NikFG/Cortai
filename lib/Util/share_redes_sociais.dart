import 'dart:io';

import 'package:social_share/social_share.dart';

class ShareRedesSociais {
  Future<Null> compartilharStoryInstagram(File file) async {
    var a = await SocialShare.shareInstagramStory(
        file.path, "#ffffff", "#000000", "");
    print(a);
  }

  Future<Null> compartilharStoryFacebook(File file) async {
    var a = await SocialShare.shareFacebookStory(
        file.path, "#ffffff", "#000000", "");
    print(a);
  }

  Future<Null> compartilharGeral(File file, {String comentario = ""}) async {
    var a = await SocialShare.shareOptions(comentario, imagePath: file.path);
    print(a);
  }
}
