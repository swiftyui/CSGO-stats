import 'dart:async';
import 'dart:convert';
import 'package:csgo_stats/src/models/custom_firebase_user.dart';
import 'package:csgo_stats/src/models/firebase_notification_details.dart';
import 'package:csgo_stats/src/models/user_data.dart';
import 'package:csgo_stats/src/services/firebase_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csgo_stats/src/firebase_admin/firebase_admin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_guid/flutter_guid.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class FirebaseAdminRestServiceException extends Error {
  final String title;
  final String message;

  FirebaseAdminRestServiceException({
    required this.title,
    required this.message,
  });
}

/// A class used to manage firebase admin interactions, it has a value
/// of the list of users within the Firebase application this class is an
/// adaptation of https://cloud.google.com/identity-platform/docs/reference/rest/v1/projects.accounts/batchGet
class FirebaseAdminServicce extends ValueNotifier<List<CustomFirebaseUser>> {
  static FirebaseAdminServicce get instance => _instance!;
  static FirebaseAdminServicce? _instance;
  static bool _wasInitialized = false;
  final ValueNotifier<bool> loadingUsers = ValueNotifier(false);
  final CollectionReference _userDataCollection =
      FirebaseFirestore.instance.collection('userData');

  /// Makes sure the that the Firebase Admin Rest Service has been called for this
  /// isolate. This can safely be executed multiple times on the same isolate,
  /// but should not be called on the Root isolate.
  static FirebaseAdminServicce ensureInitialized() {
    if (!_wasInitialized && _instance == null) {
      _wasInitialized = true;
      FirebaseAdminServicce._initialise();
    }
    return FirebaseAdminServicce.instance;
  }

  /// Initialise the service by calling the ensure initialized method
  static Future<void> _initialise() async {
    _instance = FirebaseAdminServicce._internal();
  }

  /// Start the service initialisation
  FirebaseAdminServicce._internal() : super([]);

  /// Retrieve the access token from the service acount credential
  Future<AccessToken> _getAdminAccessToken() async {
    if (FirebaseAdmin.instance.apps.isEmpty) {
      // no apps registered
      throw FirebaseAdminRestServiceException(
        title: 'Access Token Error',
        message: 'No Firebase Admin application registered',
      );
    }
    return await FirebaseAdmin.instance.apps.first.options.credential
        .getAccessToken();
  }

  /// Uses the package to determine what projectId should be returned
  Future<String> _getProjectId() async {
    return 'hobbit-steps';
  }

  /// Method used to create a new user, if a new user is successfully created
  /// an email is sent to them containing their email address and password
  Future<void> createNewUser({
    required CustomFirebaseUser newUser,
  }) async {
    value.add(newUser);
    notifyListeners();

    // get the access token from the service account credential
    AccessToken accessToken = await _getAdminAccessToken();

    // create the body for the post request
    Map<String, dynamic> data = {
      "email": newUser.email,
      "password": newUser.password,
      "displayName": newUser.name,
      "disabled": false,
      "photoUrl": newUser.imageUrl,
    };
    var body = json.encode(data);

    // send the http get request with the access token and productId
    http.Response httpResponse = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp'),
      headers: {
        'Authorization': 'Bearer ${accessToken.accessToken}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (httpResponse.statusCode != 200) {
      // something went wrong remove the new user
      value.remove(newUser);
      notifyListeners();
      throw FirebaseAdminRestServiceException(
        title: 'Http Error ${httpResponse.statusCode}',
        message: httpResponse.body,
      );
    } else {
      // Map<String, dynamic> signUpResponse = json.decode(httpResponse.body);
      // signUpResponse["localId"]; // user's uid
      // SetOptions updateOptions = SetOptions(merge: true);
      // final CollectionReference userDataCollection =
      //     FirebaseFirestore.instance.collection('userData');
      // final data = {
      //   'personalEmailAddress': newUser.email,
      //   'workEmailAddress': 'lukeskywalker@dagobah.com',
      //   'workEmailLinked': false,
      //   'isAdmin': newUser.isAdmin,
      // };
      // // set the one field or update it if it exists
      // await userDataCollection
      //     .doc(signUpResponse["localId"])
      //     .set(data, updateOptions);

      // await _sendOnboardingEmail(
      //   emailAddress: newUser.email,
      //   password: newUser.password,
      // );
      notifyListeners();
    }
  }

  /// Method to send a notification to a user through Firebase Messaging
  Future sendFirebaseCloudMessage(
      {required String userFirebaseMessagingToken,
      required String userId,
      required String notificationTitle,
      required String notificationBody}) async {
    if (userId.isEmpty) {
      if (kDebugMode) {
        print('Unable to send FCM message, no userId exists.');
      }
      return;
    }
    if (userFirebaseMessagingToken.isEmpty) {
      if (kDebugMode) {
        print('Unable to send FCM message, no token exists.');
      }
      return;
    }

    try {
      AccessToken accessToken = await FirebaseAdmin
          .instance.apps.first.options.credential
          .getAccessToken();

      Map<String, dynamic> data = {
        "message": {
          "token": userFirebaseMessagingToken,
          "notification": {
            "body": notificationBody,
            "title": notificationTitle,
          },
          "apns": {
            "payload": {
              "aps": {
                "alert": {
                  "title": notificationTitle,
                  "body": notificationBody,
                },
                "content_available": 1,
                "badge": 1,
                "sound": "mario.caf",
                "category": "message",
                "mutable-content": 1
              },
            }
          }
        }
      };
      var body = jsonEncode(data);
      http.Response httpResponse = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/hobbit-steps/messages:send'),
        headers: {
          'Authorization': 'Bearer ${accessToken.accessToken}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );
      if (httpResponse.statusCode != 200) {
        // something went wrong remove the new user
        if (kDebugMode) {
          print('ERROR ${httpResponse.statusCode} ${httpResponse.body}');
        }
      } else {
        // create the firebase notifications entry
        FirebaseNotificationService firebaseNotificationService =
            FirebaseNotificationService.ensureInitialized();
        FirebaseNotificationDetails notificationDetails =
            FirebaseNotificationDetails(
          notificationId: Guid.newGuid.toString(),
          title: notificationTitle,
          body: notificationBody,
          payload: '',
          showPopup: false,
          read: false,
          createdAt: (DateTime.now().toString()),
        );
        firebaseNotificationService.sendNotification(
          notificationDetails: notificationDetails,
          userId: userId,
        );

        if (kDebugMode) {
          print('SUCCESS ${httpResponse.statusCode} ${httpResponse.body}');
        }
      }
    } catch (_) {}
  }

  /// Method used to update the current users information
  Future<void> updateUser({required CustomFirebaseUser user}) async {
    // update the in memory user
    CustomFirebaseUser foundUser =
        value.firstWhere((element) => element.uid == user.uid);
    CustomFirebaseUser preUpdate = foundUser;
    foundUser = user;
    notifyListeners();

    // get the access token from the service account credential
    AccessToken accessToken = await _getAdminAccessToken();

    // create the body for the post request
    Map<String, dynamic> data = {
      "localId": user.uid,
      "email": user.email,
      "password": user.password,
      "displayName": user.name,
      "disabled": user.disabled,
      "photoUrl": user.imageUrl,
    };
    var body = json.encode(data);

    // send the http get request with the access token and productId
    http.Response httpResponse = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:update'),
      headers: {
        'Authorization': 'Bearer ${accessToken.accessToken}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (httpResponse.statusCode != 200) {
      // reset the user to before the update
      foundUser = value.firstWhere((element) => element.uid == user.uid);
      foundUser = preUpdate;

      notifyListeners();
      throw FirebaseAdminRestServiceException(
        title: 'Http Error ${httpResponse.statusCode}',
        message: httpResponse.body,
      );
    } else {
      // Map<String, dynamic> response = json.decode(httpResponse.body);
      // response["localId"]; // user's uid
      // SetOptions updateOptions = SetOptions(merge: true);
      // final CollectionReference userDataCollection =
      //     FirebaseFirestore.instance.collection('userData');
      // final data = {
      //   'personalEmailAddress': user.email,
      //   'isAdmin': user.isAdmin,
      // };
      // // set the one field or update it if it exists
      // await userDataCollection
      //     .doc(response["localId"])
      //     .set(data, updateOptions);
      notifyListeners();
    }
  }

  /// Method used to delete a user from the Firebase Database
  Future<void> deleteUser({required String userId}) async {
    // keep memory instance of user
    CustomFirebaseUser foundUser = value
        .firstWhere((CustomFirebaseUser adminUser) => adminUser.uid == userId);
    value.removeWhere(
      (CustomFirebaseUser adminUser) => adminUser.uid == userId,
    );
    notifyListeners();

    // get the access token from the service account credential
    AccessToken accessToken = await _getAdminAccessToken();

    // create the body for the post request
    Map<String, dynamic> data = {
      "localId": userId,
    };
    var body = json.encode(data);

    // send the http get request with the access token and productId
    http.Response httpResponse = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:delete'),
      headers: {
        'Authorization': 'Bearer ${accessToken.accessToken}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    if (httpResponse.statusCode != 200) {
      //reset the user
      value.add(foundUser);
      notifyListeners();
      throw FirebaseAdminRestServiceException(
        title: 'Http Error ${httpResponse.statusCode}',
        message: httpResponse.body,
      );
    } else {
      notifyListeners();
    }
  }

  // Get the user by Id
  Future<UserRecord?> getUserById({required String userId}) async {
    // get the access token from the service account credential
    AccessToken accessToken = await _getAdminAccessToken();

    // create the body for the post request
    Map<String, dynamic> data = {
      "localId": [
        userId,
      ]
    };
    var body = json.encode(data);

    // send the http get request with the access token and productId
    http.Response httpResponse = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:lookup'),
      headers: {
        'Authorization': 'Bearer ${accessToken.accessToken}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    if (httpResponse.statusCode != 200) {
      throw FirebaseAdminRestServiceException(
        title: 'Http Error ${httpResponse.statusCode}',
        message: httpResponse.body,
      );
    } else {
      Map<String, dynamic> data = json.decode(httpResponse.body);
      List<dynamic> users = data['users'];
      if (users.isNotEmpty) {
        return UserRecord.fromJson(users[0]);
      } else {
        return null;
      }
    }
  }

  // Get the user by email
  Future<UserRecord?> getUserByEmail({required String emailAddress}) async {
    // get the access token from the service account credential
    AccessToken accessToken = await _getAdminAccessToken();

    // create the body for the post request
    Map<String, dynamic> data = {
      "email": [
        emailAddress,
      ]
    };
    var body = json.encode(data);

    // send the http get request with the access token and productId
    http.Response httpResponse = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:lookup'),
      headers: {
        'Authorization': 'Bearer ${accessToken.accessToken}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    if (httpResponse.statusCode != 200) {
      throw FirebaseAdminRestServiceException(
        title: 'Http Error ${httpResponse.statusCode}',
        message: httpResponse.body,
      );
    } else {
      Map<String, dynamic> data = json.decode(httpResponse.body);
      List<dynamic> users = data['users'];
      if (users.isNotEmpty) {
        notifyListeners();
        return UserRecord.fromJson(users[0]);
      } else {
        return null;
      }
    }
  }

  /// get the list of users returns a list of [FirebaseUser]
  Future<void> refreshUsers() async {
    loadingUsers.value = true;
    value.clear();
    notifyListeners();

    // get the access token from the service account credential
    AccessToken accessToken = await _getAdminAccessToken();

    // get the project Id depending on the package
    String projectId = await _getProjectId();

    // send the http get request with the access token and productId
    http.Response httpResponse = await http.get(
      Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/projects/$projectId/accounts:batchGet'),
      headers: {
        'Authorization': 'Bearer ${accessToken.accessToken}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // depedning on the response code either decrypt it or throw an error
    if (httpResponse.statusCode == 200) {
      // get the internal list of users
      Map<String, dynamic> data = json.decode(httpResponse.body);
      List<dynamic> users = data['users'];
      for (var i = 0; i < users.length; i++) {
        try {
          UserRecord firebaseUser = UserRecord.fromJson(users[i]);

          UserData userData = await _getUsersData(userId: firebaseUser.uid);

          // create admin record for each user
          CustomFirebaseUser adminUser = CustomFirebaseUser(
            loading: false,
            name: firebaseUser.displayName ?? 'Bilbo Baggins',
            email: firebaseUser.email ?? 'bilbo@theshire.com',
            uid: firebaseUser.uid,
            selected: false,
            password: '',
            disabled: firebaseUser.disabled,
            imageUrl: firebaseUser.photoUrl.toString(),
            firebaseMessagingToken: userData.firebaseMessagingToken,
          );
          value.add(adminUser);
        } catch (error) {
          if (kDebugMode) {
            print('Failed to load ${users[i]}');
          }
        }
      }
      loadingUsers.value = false;
      notifyListeners();
    } else {
      loadingUsers.value = false;
      notifyListeners();
      throw FirebaseAdminRestServiceException(
        title: 'Http Error ${httpResponse.statusCode}',
        message: httpResponse.body,
      );
    }
  }

  /// Helper method to load the users data from Firebase
  Future<UserData> _getUsersData({required String userId}) async {
    DocumentSnapshot documentReference =
        await _userDataCollection.doc(userId).get();
    return UserData.fromDocumentSnapshot(
      documentReference,
      documentReference.id,
    );
  }
}
