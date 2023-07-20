import 'dart:async';
import 'dart:convert';
import 'package:csgo_stats/src/models/firebase_notification_details.dart';
import 'package:csgo_stats/src/services/local_notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseNotificationService
    extends ValueNotifier<List<FirebaseNotificationDetails>> {
  static FirebaseNotificationService get instance => _instance!;
  static FirebaseNotificationService? _instance;
  static bool _wasInitialized = false;

  late CollectionReference _notificationCollectionReference;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late StreamSubscription<QuerySnapshot> _firebaseNotificationStream;
  final ValueNotifier<bool> loadingNotifications = ValueNotifier(false);

  /// Initialise the service by calling the ensure initialized method
  static Future<void> _initialise() async {
    _instance = FirebaseNotificationService._internal();
  }

  /// Makes sure the that the Notification Services has been called for this
  /// isolate. This can safely be executed multiple times on the same isolate,
  /// but should not be called on the Root isolate.
  static FirebaseNotificationService ensureInitialized() {
    if (!_wasInitialized && _instance == null) {
      _wasInitialized = true;
      FirebaseNotificationService._initialise();
    }
    return FirebaseNotificationService.instance;
  }

  FirebaseNotificationService._internal() : super([]);

  Future markNotificationAsUnread({
    required FirebaseNotificationDetails notificationDetails,
  }) async {
    // var userNotifications = _firestore
    //     .collection("userData")
    //     .doc(UserProvider.instance.value!.uid)
    //     .collection('notifications');
    // var notification = await userNotifications
    //     .where('notificationId', isEqualTo: notificationDetails.notificationId)
    //     .get();
    // if (notification.docs.isNotEmpty) {
    //   notificationDetails.read = false;
    //   notification.docs.first.reference.update(notificationDetails.toJson());
    // }
  }

  Future markNotificationAsRead({
    required FirebaseNotificationDetails notificationDetails,
    required String userId,
  }) async {
    var userNotifications = _firestore
        .collection("userData")
        .doc(userId)
        .collection('notifications');
    var notification = await userNotifications
        .where('notificationId', isEqualTo: notificationDetails.notificationId)
        .get();
    if (notification.docs.isNotEmpty) {
      notificationDetails.read = true;
      notification.docs.first.reference.update(notificationDetails.toJson());
      notifyListeners();
    }
  }

  Future<void> subscribeToNotifications({
    required String userId,
    required bool withNotificationPopup,
  }) async {
    loadingNotifications.value = true;
    notifyListeners();

    _notificationCollectionReference = _firestore
        .collection("userData")
        .doc(userId)
        .collection('notifications');

    _firebaseNotificationStream =
        _notificationCollectionReference.snapshots().listen(
      (subscription) async {
        for (var documentChange in subscription.docChanges) {
          var notification = FirebaseNotificationDetails.fromJson(
              documentChange.doc.data() as Map<String, dynamic>);
          if (documentChange.type != DocumentChangeType.removed &&
              !value.any((element) =>
                  element.notificationId == notification.notificationId)) {
            notification.selected = false;
            value.add(notification);
            if (notification.showPopup == true && notification.read == false) {
              notification.showPopup = false;
              await documentChange.doc.reference.set(notification.toJson());
              if (withNotificationPopup == true) {
                NotificationService().showNotification(
                  title: notification.title,
                  body: NotificationAction.isValid(notification.cleanBody)
                      ? NotificationAction.fromJson(
                              json.decode(notification.cleanBody)
                                  as Map<String, dynamic>)
                          .body
                      : notification.body,
                  payload: notification.payload,
                );
              }
            }
          }
        }
        _sortNotifications();
        loadingNotifications.value = false;
        notifyListeners();
      },
    );
  }

  void _sortNotifications() {
    value.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future refreshNotifications({required String userId}) async {
    _notificationCollectionReference = _firestore
        .collection("userData")
        .doc(userId)
        .collection('notifications');

    QuerySnapshot snapshot = await _notificationCollectionReference.get();
    value = List<FirebaseNotificationDetails>.empty(growable: true);
    for (var doc in snapshot.docs) {
      var json = doc.data() as Map<String, dynamic>;
      try {
        FirebaseNotificationDetails notificationDetails =
            FirebaseNotificationDetails.fromJson(json);
        notificationDetails.selected = false;
        value.add(notificationDetails);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    _sortNotifications();
    return value;
  }

  Future sendNotification({
    required FirebaseNotificationDetails notificationDetails,
    required String userId,
  }) async {
    var userNotifications = _firestore
        .collection("userData")
        .doc(userId)
        .collection('notifications');
    userNotifications.add(notificationDetails.toJson());
  }

  Future deleteNotification({
    required String notificationId,
    required String userId,
  }) async {
    value.removeWhere((notify) => notify.notificationId == notificationId);
    notifyListeners();

    var userNotifications = _firestore
        .collection("userData")
        .doc(userId)
        .collection('notifications');

    var notification = await userNotifications
        .where('notificationId', isEqualTo: notificationId)
        .get();

    if (notification.docs.isNotEmpty) {
      notification.docs.first.reference.delete();
    }
  }

  @override
  void dispose() {
    _firebaseNotificationStream.cancel();
    super.dispose();
  }
}
