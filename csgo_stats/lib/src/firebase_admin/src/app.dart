import 'dart:async';
import 'dart:io';
import 'package:csgo_stats/src/firebase_admin/src/auth/credential.dart';
import 'package:csgo_stats/src/firebase_admin/firebase_admin.dart';
import 'package:csgo_stats/src/firebase_admin/src/app/app.dart';
import 'package:csgo_stats/src/firebase_admin/src/service.dart';

/// Represents initialized Firebase application and provides access to the
/// app's services.
class App {
  final String _name;

  final String authUrl;

  final AppOptions _options;

  final Map<Type, FirebaseService> _services = {};

  final FirebaseAppInternals _internals;

  /// Do not call this constructor directly. Instead, use
  /// [FirebaseAdmin.initializeApp] to create an app.
  App(String name, AppOptions options, this.authUrl)
      : _name = name,
        _internals = FirebaseAppInternals(options.credential),
        _options = options;

  /// The name of this application.
  ///
  /// `[DEFAULT]` is the name of the default App.
  String get name {
    _checkDestroyed();
    return _name;
  }

  /// The (read-only) configuration options for this app.
  ///
  /// These are the original parameters given in [FirebaseAdmin.initializeApp].
  AppOptions get options {
    _checkDestroyed();
    return _options;
  }

  /// Gets the [Auth] service for this application.
  Auth auth() => _getService(() => Auth(this));

  /// Renders this app unusable and frees the resources of all associated
  /// services.
  Future<void> delete() async {
    _checkDestroyed();
    FirebaseAdmin.instance.removeApp(_name);

    internals.delete();

    await Future.wait(_services.values.map((v) => v.delete()));
    _services.clear();
  }

  T _getService<T extends FirebaseService>(T Function() factory) {
    _checkDestroyed();
    return (_services[T] ??= factory()) as T;
  }

  /// Throws an Error if the FirebaseApp instance has already been deleted.
  void _checkDestroyed() {
    if (internals.isDeleted) {
      throw FirebaseAppError.appDeleted(
        'Firebase app named "$_name" has already been deleted.',
      );
    }
  }

  String getProjectId() {
    final options = _options;
    if (options.projectId != null && options.projectId!.isNotEmpty) {
      return options.projectId!;
    }

    final cert = _tryGetCertificate(options.credential);
    if (cert != null && cert.projectId != null && cert.projectId!.isNotEmpty) {
      return cert.projectId!;
    }

    final projectId = Platform.environment['GOOGLE_CLOUD_PROJECT'] ??
        Platform.environment['GCLOUD_PROJECT'];
    if (projectId != null && projectId.isNotEmpty) {
      return projectId;
    }

    throw FirebaseAuthError.invalidCredential(
      'Must initialize app with a cert credential or set your Firebase project '
      'ID as the GOOGLE_CLOUD_PROJECT environment variable.',
    );
  }

  Certificate? _tryGetCertificate(Credential credential) {
    if (credential is FirebaseCredential) {
      return credential.certificate;
    }
    return null;
  }
}

extension AppInternalsExtension on App {
  FirebaseAppInternals get internals => _internals;
}

/// Available options to pass to initializeApp().
class AppOptions {
  /// A [Credential] object used to authenticate the Admin SDK.
  ///
  /// You can obtain a credential via one of the following methods:
  ///
  /// - [applicationDefaultCredential]
  /// - [cert]
  /// - [refreshToken]
  final Credential credential;

  /// The URL of the Realtime Database from which to read and write data.
  final String? databaseUrl;

  /// The ID of the Google Cloud project associated with the App.
  final String? projectId;

  /// The name of the default Cloud Storage bucket associated with the App.
  final String? storageBucket;

  /// The client email address of the service account.
  final String? serviceAccountId;

  AppOptions({
    required this.credential,
    this.databaseUrl,
    this.projectId,
    this.storageBucket,
    this.serviceAccountId,
  });
}
