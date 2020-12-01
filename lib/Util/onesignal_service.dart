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
    });
  }
}
