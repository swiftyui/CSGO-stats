import 'dart:convert';
import 'package:snapshot/snapshot.dart';
import 'package:csgo_stats/src/firebase_admin/src/auth.dart';

/// 'REDACTED', encoded as a base64 string.
final _b64Redacted = base64.encode('REDACTED'.codeUnits);

final userRecordDecoder = SnapshotDecoder()
  ..register<Map<String, dynamic>, UserRecord>((v) => UserRecord.fromJson(v))
  ..register<Snapshot, UserMetadata>((s) => UserMetadata(s))
  ..register<Snapshot, UserInfo>((s) => UserInfo(s))
  ..register<String, DateTime>(
    (v) => DateTime.fromMicrosecondsSinceEpoch(
        (num.parse(v) * 1000 * 1000).toInt()),
    format: RegExp('epoch'),
  )
  ..register<String, DateTime>(
    (v) => DateTime.fromMicrosecondsSinceEpoch((num.parse(v) * 1000).toInt()),
    format: RegExp('epoch:millis'),
  )
  ..seal();

/// User metadata class that provides metadata information like user account
/// creation and last sign in time.
mixin UserMetadataMixin on SnapshotView {
  /// The date the user was created
  DateTime get creationTime => get('createdAt', format: 'epoch:millis');

  /// The time at which the user was last active (ID token refreshed).
  ///
  /// Returns null if the user was never active.
  DateTime? get lastRefreshTime => get('lastRefreshAt');

  /// The date the user last signed in, formatted as a UTC string.
  DateTime? get lastSignInTime => get('lastLoginAt', format: 'epoch:millis');
}

class UserMetadata = UnmodifiableSnapshotView with UserMetadataMixin;

/// User info class that provides provider user information for different
/// Firebase providers like google.com, facebook.com, password, etc.
mixin UserInfoMixin on SnapshotView {
  /// The user identifier for the linked provider.
  String get uid => get('rawId');

  /// The display name for the linked provider.
  String? get displayName => get('displayName');

  /// The email for the linked provider.
  String? get email => get('email');

  /// The photo URL for the linked provider.
  Uri? get photoUrl => get('photoUrl');

  /// The linked provider ID (for example, "google.com" for the Google provider).
  String get providerId => get('providerId');

  /// The phone number for the linked provider.
  String? get phoneNumber => get('phoneNumber');
}

class UserInfo = UnmodifiableSnapshotView with UserInfoMixin;

/// Represents a user.
mixin UserRecordMixin on SnapshotView {
  /// The user's uid.
  String get uid => get('localId');

  /// The user's primary email, if set.
  String? get email => get('email');

  /// Whether or not the user's primary email is verified.
  bool get emailVerified => get('emailVerified') ?? false;

  /// The user's display name.
  String? get displayName => get('displayName');

  /// The user's photo URL.
  Uri? get photoUrl => get('photoUrl');

  /// The user's primary phone number, if set.
  String? get phoneNumber => get('phoneNumber');

  /// Whether or not the user is disabled.
  bool get disabled => get('disabled') ?? false;

  /// Additional metadata about the user.
  UserMetadata get metadata => snapshot.as();

  /// An array of providers (for example, Google, Facebook) linked to the user.
  List<UserInfo> get providerData => getList('providerUserInfo') ?? [];

  /// The user's hashed password (base64-encoded), only if Firebase Auth hashing
  /// algorithm (SCRYPT) is used.
  ///
  /// If a different hashing algorithm had been used when uploading this user,
  /// as is typical when migrating from another Auth system, this will be an
  /// empty string. If no password is set, this is null. This is only available
  /// when the user is obtained from [Auth.listUsers].
  String? get passwordHash =>
      get('passwordHash') == _b64Redacted ? null : get('passwordHash');

  /// The user's password salt (base64-encoded), only if Firebase Auth hashing
  /// algorithm (SCRYPT) is used.
  ///
  /// If a different hashing algorithm had been used to upload this user,
  /// typical when migrating from another Auth system, this will be an empty
  /// string. If no password is set, this is null. This is only available when
  /// the user is obtained from [Auth.listUsers].
  String? get passwordSalt => get('salt') ?? '';

  /// The user's custom claims object if available, typically used to define
  /// user roles and propagated to an authenticated user's ID token.
  ///
  /// This is set via [Auth.setCustomUserClaims].
  Map<String, dynamic>? get customClaims =>
      get('customAttributes', format: 'json');

  /// The ID of the tenant the user belongs to, if available.
  String? get tenantId => get('tenantId');

  /// The date the user's tokens are valid after.
  ///
  /// This is updated every time the user's refresh token are revoked either
  /// from the [Auth.revokeRefreshTokens] API or from the Firebase Auth backend
  /// on big account changes (password resets, password or email updates, etc).
  DateTime? get tokensValidAfterTime => get('validSince', format: 'epoch');
}

class UserRecord = UnmodifiableSnapshotView with UserRecordMixin;
