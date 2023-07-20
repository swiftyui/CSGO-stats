import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String id;
  String firebaseMessagingToken;

  UserData({
    required this.id,
    required this.firebaseMessagingToken,
  });

  UserData.fromDocumentSnapshot(
    DocumentSnapshot doc,
    this.id,
  ) : firebaseMessagingToken =
            doc.data().toString().contains('firebaseMessagingToken')
                ? doc.get('firebaseMessagingToken')
                : '';
}
