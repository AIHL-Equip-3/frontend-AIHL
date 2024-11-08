import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LoginWebView extends StatefulWidget {
  const LoginWebView({super.key});

  @override
  State<LoginWebView> createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  late InAppWebViewController _webViewController;
  String? token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(
              'https://valid.aoc.cat/o/oauth2/auth?lang=ca&scope=autenticacio_usuari&redirect_uri=https://ovt.gencat.cat/carpetaciutadana360/AppJava/api/login&response_type=code&client_id=gsit.gencat.cat&approval_prompt=auto&state=inici_set-locale=ca_ES'),
        ),
        initialSettings: InAppWebViewSettings(
          useShouldInterceptAjaxRequest: true,
          useShouldInterceptFetchRequest: true,
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        shouldInterceptAjaxRequest: (controller, ajaxRequest) async {
          if (ajaxRequest.url.toString().contains(
              '/carpetaciutadana360/mfe-main-app/AppJava/api/token')) {
            print('Ajax request intercepted: ${ajaxRequest.url}');
            _webViewController.addJavaScriptHandler(
              handlerName: 'ajaxHandler',
              callback: (args) async {
                var ajaxResponse = args[0];
                print('Ajax response received: $ajaxResponse');
                try {
                  Map<String, dynamic> jsonResponse = jsonDecode(ajaxResponse);
                  token = jsonResponse['token'];
                  print('Token captured: $token');
                } catch (e) {
                  print('Error decoding response: $e');
                }
                return ajaxResponse;
              },
            );
          }
          return ajaxRequest;
        },
        shouldInterceptFetchRequest: (controller, fetchRequest) async {
          if (fetchRequest.url.toString().contains(
              '/carpetaciutadana360/mfe-main-app/AppJava/api/token')) {
            print('Fetch request intercepted: ${fetchRequest.url}');
            controller.addJavaScriptHandler(
              handlerName: 'fetchHandler',
              callback: (args) async {
                var fetchResponse = args[0];
                print('Fetch response received: $fetchResponse');
                try {
                  Map<String, dynamic> jsonResponse = jsonDecode(fetchResponse);
                  token = jsonResponse['token'];
                  print('Token captured: $token');
                } catch (e) {
                  print('Error decoding response: $e');
                }
                return fetchResponse;
              },
            );
          }
          return fetchRequest;
        },
        onLoadError: (controller, url, code, message) {
          print('Error loading page: $message');
        },
        onConsoleMessage: (controller, consoleMessage) {
          print('Console message: ${consoleMessage.message}');
        },
      ),
    );
  }
}
