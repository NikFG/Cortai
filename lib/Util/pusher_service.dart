import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pusher_websocket_flutter/pusher.dart';

const APP_KEY = '2b6fd1658e6d346df238';
const PUSHER_CLUSTER = 'us2';

class PusherService {
  StreamController<String> _eventData = StreamController<String>();

  Sink get _inEventData => _eventData.sink;

  Stream get eventStream => _eventData.stream;
  Event lastEvent;
  String lastConnectionState;
  Channel channel;
  Map<String, dynamic> json;

  Future<void> initPusher() async {
    try {
      // await Pusher.init(APP_KEY, PusherOptions(cluster: PUSHER_CLUSTER,auth: PusherAuth('/broadcasting/auth',)));
      await Pusher.init(
          APP_KEY,
          PusherOptions(
            cluster: PUSHER_CLUSTER,
            // encrypted: false,
            // auth: PusherAuth('http://192.168.0.108:8000/broadcasting/auth',
            //     headers: {
            //       'Authorization': 'Bearer $token',
            //     }),
          ),
          enableLogging: true);
    } on PlatformException catch (e) {
      print("Erro de auth" + e.message);
    }
  }

  void connectPusher() {
    Pusher.connect(
        onConnectionStateChange: (ConnectionStateChange connectionState) async {
      lastConnectionState = connectionState.currentState;
    }, onError: (ConnectionError e) {
      print("Error: ${e.message}");
    });
  }

  Future<void> subscribePusher(String channelName) async {
    channel = await Pusher.subscribe(channelName);
  }

  void unSubscribePusher(String channelName) {
    Pusher.unsubscribe(channelName);
  }

  void bindEvent(String eventName) {
    channel.bind(eventName, (last) {
      final String data = last.data;
      _inEventData.add(data);
    });
  }

  void unbindEvent(String eventName) {
    channel.unbind(eventName);
    _eventData.close();
  }

  Future<void> firePusher(
      {@required String channelName,
      @required String eventName,
      Map<String, dynamic> json}) async {
    print(channelName);
    await initPusher();
    connectPusher();
    await subscribePusher(channelName);
    bindEvent(eventName);
  }
}
