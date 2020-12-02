import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static const APP_ID = "c57847eb-ff08-4b71-ba02-e2abc1e72422";

  OneSignalService.init() {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.init(APP_ID, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      print(notification.jsonRepresentation());
      print(notification.payload);
    });
  }

  void gravaToken(int id, String token) async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    Dio dio = Dio();
    FormData data =
        FormData.fromMap({'onesignal_token': status.subscriptionStatus.userId});
    var response = await dio.post(
        Util.url + "auth/user/update/${id.toString()}/onesignal",
        data: data,
        options: Options(headers: Util.token(token)));
    if (response.statusCode == 200) {
      print("ok");
    }
  }

  void gravaIdExterna(bool isCabeleireiro, bool isDonoSalao, int id) async {

    await OneSignal.shared.setExternalUserId(id.toString());
    await OneSignal.shared.sendTags({
      "cabeleireiro": isCabeleireiro.toString(),
      "dono_salao": isDonoSalao.toString(),
    });
  }
}
