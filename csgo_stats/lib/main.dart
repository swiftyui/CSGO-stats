import 'dart:convert';
import 'package:csgo_stats/csgo_stats_app.dart';
import 'package:csgo_stats/firebase_options.dart';
import 'package:csgo_stats/src/blocs/app_bloc_observer.dart';
import 'package:csgo_stats/src/firebase_admin/firebase_admin.dart';
import 'package:csgo_stats/src/firebase_admin/src/auth/credential.dart';
import 'package:csgo_stats/src/services/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize the Firebase App
  await _setupFirebase();
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  Bloc.observer = const AppBlocObserver();
  await _setupFirebase();
  await _initializeServices();

  runApp(const CSGOStatsApp());
}

Future _initializeServices() async {
  await NotificationService().initNotification();
}

Future _setupFirebase() async {
  // Initialize the Firebase App
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'csgo-stats-ea61f',
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize the Firebase Messsaging

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: false,
    badge: false,
    sound: false,
  );

  // Initialize the Firebase Admin SDK
  final String response =
      await rootBundle.loadString('assets/firebase/service_account.json');
  final data = await json.decode(response);
  var accountCredential = ServiceAccountCredential.fromJson(data);

  FirebaseAdmin.instance.initializeApp(
    'https://identitytoolkit.googleapis.com/',
    AppOptions(
      credential: accountCredential,
      projectId: 'csgo-stats-ea61f',
    ),
  );

  //load any messages sent whilst the app was terminated
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      // the sender should have already created the database entry
      // we only need to show the popup
      NotificationService().showNotification(
        body: message.notification?.body,
        payload: '',
        title: message.notification?.title,
      );
    }
  });

  // Listen to Firebase Message Notifications
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      // the sender should have already created the database entry
      // we only need to show the popup
      NotificationService().showNotification(
        body: message.notification?.body,
        payload: '',
        title: message.notification?.title,
      );
    },
  );

  // When a Notification has been clicked
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('A new onMessageOpenedApp event was published!');
    }
  });
}
