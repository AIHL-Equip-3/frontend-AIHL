import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _openLoginWebView() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginWebView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _openLoginWebView,
          child: const Text('Iniciar Sesión'),
        ),
      ),
    );
  }
}

class LoginWebView extends StatefulWidget {
  const LoginWebView({super.key});

  @override
  State<LoginWebView> createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          'https://valid.aoc.cat/o/oauth2/auth?lang=ca&scope=autenticacio_usuari&redirect_uri=https://ovt.gencat.cat/carpetaciutadana360/AppJava/api/login&response_type=code&client_id=gsit.gencat.cat&approval_prompt=auto&state=inici_set-locale=ca_ES'))
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          _handleUrlChange(url);
        },
        onPageFinished: (String url) {
          _handleUrlChange(url);
        },
        onNavigationRequest: (NavigationRequest request) {
          _handleUrlChange(request.url);
          return NavigationDecision.navigate;
        },
      ));
  }

  void _handleUrlChange(String url) {
    if (url.contains(
        'https://ovt.gencat.cat/carpetaciutadana360/mfe-main-app/#/onboarding')) {
      // Aquí puedes realizar acciones adicionales si es necesario
      Navigator.pop(context);
    }
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
