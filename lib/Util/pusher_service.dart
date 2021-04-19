import 'dart:async';
import 'package:cortai/Util/util.dart';
import 'package:flutter/services.dart';
import 'package:pusher_client/pusher_client.dart';

const APP_KEY = '2b6fd1658e6d346df238';
const PUSHER_CLUSTER = 'us2';
const URL = 'http://192.168.0.108:8000/broadcasting/auth';

class PusherService {
  StreamController<String> _eventData = StreamController<String>();

  Sink get _inEventData => _eventData.sink;

  Stream get eventStream => _eventData.stream;
  late PusherClient pusher;
  late String lastConnectionState;
  late Channel channel;

  Future<void> initPusher(String token) async {
    var auth = PusherAuth(URL, headers: Util.token(token));
    var options = PusherOptions(
      cluster: PUSHER_CLUSTER,
      encrypted: true,
      auth: auth,
    );
    try {
      pusher = PusherClient(APP_KEY, options, autoConnect: false);
    } on PlatformException catch (e) {
      print("Erro de auth" + e.message.toString());
    }
  }

  void connectPusher() {
    pusher.connect();
  }

  void subscribePusher(String channelName) {
    channel = pusher.subscribe(channelName);
  }

  void unSubscribePusher(String channelName) {
    pusher.unsubscribe(channelName);
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

  Future<void> firePusher({
    required String channelName,
    required String eventName,
    required token,
  }) async {
    print(channelName);
    await initPusher(token);
    connectPusher();
    subscribePusher(channelName);
    bindEvent(eventName);
  }
}
