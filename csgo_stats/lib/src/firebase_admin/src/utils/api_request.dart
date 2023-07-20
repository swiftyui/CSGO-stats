// ignore_for_file: depend_on_referenced_packages

import 'package:http/http.dart';
import 'package:csgo_stats/src/firebase_admin/src/app.dart';

class AuthorizedHttpClient extends BaseClient {
  final App app;

  final Duration? timeout;

  final Client client = httpClientFactory();

  AuthorizedHttpClient(this.app, [this.timeout]);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    var accessTokenObj = await app.internals.getToken();

    request.headers['Authorization'] = 'Bearer ${accessTokenObj.accessToken}';

    var r = client.send(request);
    if (timeout != null) r = r.timeout(timeout!);
    return r;
  }

  static Client Function() httpClientFactory = () => Client();
}
