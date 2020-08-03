import 'dart:async';

import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewTela extends StatelessWidget {
  final String url;
  final String titulo;

  WebViewTela(this.url, this.titulo);

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Util.leadingScaffold(context),
          title: Text(titulo),
          centerTitle: true,
        ),
        body: WebView(
          key: UniqueKey(),
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          gestureNavigationEnabled: true,
        ));
  }
}
