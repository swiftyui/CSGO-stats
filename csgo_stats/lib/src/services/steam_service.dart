import 'dart:convert';

import 'package:csgo_stats/main.dart';
import 'package:csgo_stats/src/models/steam_user.dart';
import 'package:csgo_stats/src/views/agreement_popup/agreement_popup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class SteamService {
  static SteamService get instance => _instance!;
  static SteamService? _instance;
  static bool _wasInitialized = false;
  static const String _steamWebApiKey = "5DB47945E1E7A1B1C2758370C6921C4A";
  final UniqueKey _webViewKey = UniqueKey();
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
  late final SharedPreferences _sharedPreferences;
  late String _steamUserId;
  late SteamUser _steamUser;

  /// Makes sure the that the Firebase Admin Rest Service has been called for this
  /// isolate. This can safely be executed multiple times on the same isolate,
  /// but should not be called on the Root isolate.
  static SteamService ensureInitialized() {
    if (!_wasInitialized && _instance == null) {
      _wasInitialized = true;
      SteamService._initialise();
    }
    return SteamService.instance;
  }

  /// Initialise the service by calling the ensure initialized method
  static Future<void> _initialise() async {
    _instance = SteamService._internal();
  }

  /// Start the service initialisation
  SteamService._internal() : super() {
    _getStoredValues();
  }

  Future _getStoredValues() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _steamUserId = _sharedPreferences.getString('steamUserId') ?? "";
    if (_steamUserId.isEmpty) {
      return;
    }
    // get the steam user's details
    _steamUser = await _getSteamUser();
  }

  Future<String?> signInToSteam() async {
    final launchUri = Uri.parse('https://steamcommunity.com/login/home/?goto=');
    final controller = WebViewController();
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: _onNavigationRequest,
      ),
    );
    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.clearCache();
    await controller.clearLocalStorage();
    await controller.setBackgroundColor(Colors.transparent);
    await controller.loadRequest(launchUri);
    await controller.enableZoom(false);
    final webView = WebViewWidget(
      key: _webViewKey,
      gestureRecognizers: gestureRecognizers,
      controller: controller,
    );

    if (!kIsWeb) {
      // first display the agreement popup
      await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => const AgreementPopup(),
      ).then((value) async {
        if (value == true) {
          await showModalBottomSheet(
            isScrollControlled: true,
            elevation: 3,
            isDismissible: true,
            useSafeArea: true,
            enableDrag: true,
            context: navigatorKey.currentContext!,
            builder: (context) => Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.2,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(27, 40, 56, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16.0),
                  topLeft: Radius.circular(16.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    webView,
                  ],
                ),
              ),
            ),
          );
        }
      });
    }

    // securely store the user's id
    await _sharedPreferences.setString('steamUserId', _steamUserId);
    // get the steam user's details
    _steamUser = await _getSteamUser();
    return _steamUserId;
  }

  Future<NavigationDecision> _onNavigationRequest(
    NavigationRequest request,
  ) async {
    var re = RegExp(r'(?<=profiles/)(.*)(?=/goto)');
    var match = re.firstMatch(request.url);
    if (match != null) {
      _steamUserId = match.group(0) ?? "";
      navigatorKey.currentState!.pop();
    }
    if (request.url
            .startsWith('https://steamcommunity.com/login/home/?goto=') ||
        request.url.startsWith('https://steamcommunity.com/my/goto') ||
        request.url.startsWith('https://steamcommunity.com/profiles/')) {
      return NavigationDecision.navigate;
    }
    return NavigationDecision.prevent;
  }

  Future<SteamUser> _getSteamUser() async {
    final uri = Uri.parse(
        'http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=$_steamWebApiKey&steamids=$_steamUserId');

    var httpResponse = await http.get(
      uri,
    );

    if (httpResponse.statusCode == 200) {
      try {
        Map<String, dynamic> data = json.decode(httpResponse.body);

        // Accessing the decoded values
        Map<String, dynamic> response = data['response'];
        List<dynamic> players = response['players'];
        return SteamUser.fromJson(players[0]);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        throw SteamServiceException('No User Found');
      }
    } else {
      var jsonResponse = jsonDecode(httpResponse.body);
      throw SteamServiceException(jsonResponse.toString());
    }
  }
}

class SteamServiceException extends Error {
  final String message;

  SteamServiceException(this.message);
}
