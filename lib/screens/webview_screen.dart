import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  double progress = 0;
  String? token;

  // URL inicial del WebView
  final String initialUrl =
      'https://ovt.gencat.cat/carpetaciutadana360/mfe-main-app/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
        // Puedes agregar botones de navegación si lo deseas
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              webViewController?.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(initialUrl)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                javaScriptEnabled: true,
              ),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
              ),
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                progress = 0;
              });
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
            onAjaxReadyStateChange: (controller, ajaxRequest) async {
              if (ajaxRequest.url?.toString().contains('/api/token') == true &&
                  ajaxRequest.readyState == 4 &&
                  ajaxRequest.status == 200) {
                final responseText = ajaxRequest.responseText;
                if (responseText != null) {
                  try {
                    final Map<String, dynamic> response =
                        jsonDecode(responseText);
                    setState(() {
                      token = response['token'];
                    });
                    print('Token capturado: $token');
                    // Aquí puedes hacer lo que necesites con el token
                    // Por ejemplo, guardarlo en un estado global o en almacenamiento local
                  } catch (e) {
                    print('Error al procesar el token: $e');
                  }
                }
              }
            },
            onConsoleMessage: (controller, consoleMessage) {
              print('Console: ${consoleMessage.message}');
            },
            onLoadError: (controller, url, code, message) {
              print('Error de carga: $message');
            },
            onLoadHttpError: (controller, url, statusCode, description) {
              print('Error HTTP: $statusCode - $description');
            },
          ),
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container(),
        ],
      ),
    );
  }
}
