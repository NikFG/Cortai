import 'dart:async';

import 'package:agendacabelo/Util/util.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SugerirSalaoTela extends StatelessWidget {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Util.leadingScaffold(context),
          title: Text("Sugerir um novo salão"),
          centerTitle: true,
        ),
        body: WebView(
          key: UniqueKey(),
          initialUrl:
              'https://docs.google.com/forms/d/e/1FAIpQLSdbwi9TmLX0YPW6B7TFJCHnFwuUe80lgPPbBu0mhzrvMgJSbw/viewform?usp=sf_link',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },

          gestureNavigationEnabled: true,
        ));
  }
}
