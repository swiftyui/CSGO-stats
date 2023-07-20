import 'package:openid_client/openid_client.dart';
import 'package:meta/meta.dart';
import 'package:csgo_stats/src/firebase_admin/firebase_admin.dart';
import 'package:csgo_stats/src/firebase_admin/src/utils/validator.dart'
    as validator;

/// Class for verifying general purpose Firebase JWTs.
///
/// This verifies ID tokens and session cookies.
class FirebaseTokenVerifier {
  final App app;
  final String projectId;

  final String _jwtName = 'ID token';

  static FirebaseTokenVerifier Function(App app) factory =
      (app) => FirebaseTokenVerifier(app);

  FirebaseTokenVerifier(this.app) : projectId = app.getProjectId();

  /// Verifies the format and signature of a Firebase Auth JWT token.
  Future<IdToken> verifyJwt(String jwtToken) async {
    var client = await getOpenIdClient();

    var credential = client.createCredential(idToken: jwtToken);

    await for (var e in credential.validateToken()) {
      throw FirebaseAuthError.invalidArgument(
        'Validating $_jwtName failed: $e',
      );
    }

    if (!validator.isUid(credential.idToken.claims.subject)) {
      throw FirebaseAuthError.invalidArgument(
        '$_jwtName has "sub" (subject) claim which is not a valid uid',
      );
    }

    return credential.idToken;
  }

  @visibleForTesting
  Future<Client> getOpenIdClient() async {
    var issuer = await Issuer.discover(Issuer.firebase(projectId));
    return Client(issuer, projectId);
  }
}
