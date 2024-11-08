import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebView extends StatefulWidget {
  const LoginWebView({super.key});

  @override
  State<LoginWebView> createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  late final WebViewController _controller;
  String? token;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'TokenChannel',
        onMessageReceived: (JavaScriptMessage message) {
          String responseText = message.message;
          print('Respuesta recibida: $responseText');
          try {
            Map<String, dynamic> jsonResponse = jsonDecode(responseText);
            token = jsonResponse['token'];
            print('Token: $token');
            // Puedes usar el token aquí
          } catch (e) {
            print('Error al decodificar la respuesta: $e');
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _injectJavaScript();
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://valid.aoc.cat/o/oauth2/auth?lang=ca&scope=autenticacio_usuari&redirect_uri=https://ovt.gencat.cat/carpetaciutadana360/AppJava/api/login&response_type=code&client_id=gsit.gencat.cat&approval_prompt=auto&state=inici_set-locale=ca_ES'));
  }

  void _injectJavaScript() {
    String js = """
      (function() {
        // Interceptar XMLHttpRequest
        var open = XMLHttpRequest.prototype.open;
        XMLHttpRequest.prototype.open = function(method, url) {
          this.addEventListener('load', function() {
            if (url.includes('/carpetaciutadana360/mfe-main-app/AppJava/api/token')) {
              TokenChannel.postMessage(this.responseText);
            }
          });
          open.apply(this, arguments);
        };

        // Interceptar fetch
        var originalFetch = window.fetch;
        window.fetch = function() {
          return originalFetch.apply(this, arguments).then(function(response) {
            if (response.url.includes('/carpetaciutadana360/mfe-main-app/AppJava/api/token')) {
              response.clone().text().then(function(bodyText) {
                TokenChannel.postMessage(bodyText);
              });
            }
            return response;
          });
        };
      })();
    """;

    _controller.runJavaScript(js);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
