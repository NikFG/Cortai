import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static const APP_ID = "c57847eb-ff08-4b71-ba02-e2abc1e72422";

  OneSignalService.init() {
    _inicializa();
  }

  void gravaIdExterna(bool isCabeleireiro, bool isDonoSalao, int id) async {
    await OneSignal.shared.setExternalUserId(id.toString());
    await OneSignal.shared.sendTags({
      "cabeleireiro": isCabeleireiro.toString(),
      "dono_salao": isDonoSalao.toString(),
    });
  }

  void _inicializa() async {
    await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.setAppId(APP_ID);

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();
    print(requiresConsent);
    await OneSignal.shared.disablePush(false);
    OneSignal.shared.setNotificationOpenedHandler((event) {
      print(event.notification.jsonRepresentation());
      print(event.notification.rawPayload);
    });
  }
}
