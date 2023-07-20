class CustomFirebaseUser {
  String name;
  String email;
  String uid;
  String password;
  String imageUrl;
  String firebaseMessagingToken;
  bool selected;
  bool disabled;
  bool loading;

  CustomFirebaseUser({
    required this.name,
    required this.email,
    required this.uid,
    required this.selected,
    required this.loading,
    required this.password,
    required this.disabled,
    required this.imageUrl,
    required this.firebaseMessagingToken,
  });
}
