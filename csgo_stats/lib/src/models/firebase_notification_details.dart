import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';

class FirebaseNotificationDetails {
  final String notificationId;
  final String title;
  final String body;
  final String payload;
  final String createdAt;
  late bool? selected;

  bool read;
  bool showPopup;

  String get cleanBody {
    return body
        .replaceAll('\'', '')
        .replaceAll('\n', '')
        .replaceAll('\r', '')
        .replaceAll('\t', '')
        .replaceAll('\\"', '"');
  }

  FirebaseNotificationDetails({
    notificationId,
    required this.title,
    required this.payload,
    required this.body,
    this.showPopup = true,
    createdAt,
    this.read = false,
    this.selected,
  })  : createdAt = (createdAt ?? Timestamp.now().toString()),
        notificationId = Guid.newGuid.toString();

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'title': title,
      'body': body,
      'payload': payload,
      'showPopup': showPopup,
      'createdAt': createdAt,
      'read': read,
    };
  }

  FirebaseNotificationDetails.fromJson(Map<String, dynamic> jsonData)
      : notificationId = jsonData.containsKey('notificationId')
            ? jsonData['notificationId']
            : '',
        title = jsonData.containsKey('title') ? jsonData['title'] : '',
        body = jsonData.containsKey('body') ? jsonData['body'] : '',
        payload = jsonData.containsKey('payload') ? jsonData['payload'] : '',
        showPopup =
            jsonData.containsKey('showPopup') ? jsonData['showPopup'] : false,
        createdAt = jsonData.containsKey('createdAt')
            ? jsonData['createdAt']
            : Timestamp.now().toString(),
        read = jsonData.containsKey('read') ? jsonData['read'] : false;
}

class NotificationAction {
  final String body;
  final String notificationAction;
  final List<dynamic> extraData;

  NotificationAction({
    required this.body,
    required this.notificationAction,
    required this.extraData,
  });

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'notificationAction': notificationAction,
      'extraData': extraData,
    };
  }

  NotificationAction.fromJson(Map<String, dynamic> jsonData)
      : body = jsonData.containsKey('body') ? jsonData['body'] : '',
        notificationAction = jsonData.containsKey('notificationAction')
            ? jsonData['notificationAction']
            : '',
        extraData =
            jsonData.containsKey('extraData') ? jsonData['extraData'] : [];

  static bool isValid(String raw) {
    try {
      Map<String, dynamic> decoded = json.decode(raw);
      var jsonData = NotificationAction.fromJson(decoded);
      return jsonData.notificationAction.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> invoke(BuildContext context) async {
    switch (notificationAction) {
      case NotificationType.openRoute:
        // CarouselItem? carouselItem =
        //     CarouselConfig().getCarouselItem(extraData[0]);
        // if (carouselItem != null) {
        //   // Navigate to a specific carousel page
        //   Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => PageDetails(
        //       extendBehindAppBar: carouselItem.extendBehindAppBar,
        //       page: carouselItem.page,
        //       title: carouselItem.title,
        //     ),
        //   ));
        // }

        break;
      case NotificationType.awardAchievement:
        // for (var achievementId in extraData) {
        //   MyAchievementService.instance.awardAchievement(achievementId);
        // }
        break;
      case NotificationType.friendRequest:
        // // Navigate to the friend request page
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => const FriendsListScreen(),
        // ));

        break;
    }
  }
}

class NotificationType {
  static const String friendRequest = 'friendRequest';
  static const String openRoute = 'openRoute';
  static const String awardAchievement = 'awardAchievement';
}
