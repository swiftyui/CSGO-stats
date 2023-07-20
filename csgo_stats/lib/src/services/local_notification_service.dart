import 'dart:async';
import 'package:csgo_stats/src/models/received_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

int id = 0;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

final List<DarwinNotificationCategory> darwinNotificationCategories =
    <DarwinNotificationCategory>[
  DarwinNotificationCategory(
    darwinNotificationCategoryText,
    actions: <DarwinNotificationAction>[
      DarwinNotificationAction.text(
        'text_1',
        'Action 1',
        buttonTitle: 'Send',
        placeholder: 'Placeholder',
      ),
    ],
  ),
  DarwinNotificationCategory(
    darwinNotificationCategoryPlain,
    actions: <DarwinNotificationAction>[
      DarwinNotificationAction.plain('id_1', 'Action 1'),
      DarwinNotificationAction.plain(
        'id_2',
        'Action 2 (destructive)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.destructive,
        },
      ),
      DarwinNotificationAction.plain(
        navigationActionId,
        'Action 3 (foreground)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        'id_4',
        'Action 4 (auth required)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.authenticationRequired,
        },
      ),
    ],
    options: <DarwinNotificationCategoryOption>{
      DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
    },
  )
];

class NotificationService {
  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  Future<void> initNotification() async {
    // final service = FlutterBackgroundService();

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('launcher_icon');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
      notificationCategories: darwinNotificationCategories,
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    _configureSelectNotificationSubject();
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      // if (payload == PayloadList.updateApp) {
      //   // open request to website where latest version can be downloaded
      //   final uri =
      //       Uri.parse('https://dagobah.entelectprojects.co.za/download/#');
      //   if (!await launchUrl(
      //     uri,
      //     mode: LaunchMode.externalApplication,
      //   )) {
      //     throw Exception('Could not launch $uri');
      //   }
      // } else if (payload == PayloadList.friendRequest) {}
    });
  }

  Future<NotificationDetails> notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future showNotification({
    String? title,
    String? body,
    String? payload,
  }) async {
    return await flutterLocalNotificationsPlugin.show(
      id++,
      title,
      body,
      await notificationDetails(),
      payload: payload,
    );
  }

  Future scheduleNotification(
    String? title,
    String? body,
    Duration scheduledIn,
  ) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id++,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(scheduledIn),
        const NotificationDetails(
          android: AndroidNotificationDetails('channelId', 'channelName',
              channelDescription: 'channelDescription'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime);
  }
}

class PayloadList {
  static String get calorieGoalAchieved => 'CALORIE_GOAL_ACHIEVED';
  static String get standingGoalAchieved => 'STANDING_GOAL_ACHIEVED';
  static String get exerciseGoalAchieved => 'EXERCISE_GOAL_ACHIEVED';
  static String get allGoalsAchieved => 'ALL_GOALS_ACHIEVED';
}
