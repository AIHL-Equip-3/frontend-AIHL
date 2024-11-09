import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoadingResponse =
      false; // Variable para indicar si está cargando respuesta

  void _handleSendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        String timestamp = DateFormat('HH:mm').format(DateTime.now());
        _messages.add({'user': _controller.text, 'time': timestamp});
        _controller.clear();
        _isLoadingResponse = true; // Activa la animación de carga
      });
      _handleChatbotResponse();
    }
  }

  void _handleChatbotResponse() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        String timestamp = DateFormat('HH:mm').format(DateTime.now());
        _messages.add(
            {'bot': 'Esta es una respuesta del chatbot.', 'time': timestamp});
        _isLoadingResponse = false; // Desactiva la animación de carga
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 60.0),
              itemCount: _messages.length + (_isLoadingResponse ? 1 : 0),
              itemBuilder: (context, index) {
                // Define un estilo de texto común para el mensaje del bot y el mensaje de carga
                const TextStyle botTextStyle = TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A4A4A),
                );

                if (_isLoadingResponse && index == _messages.length) {
                  // Caja gris con animación de carga en lugar de texto del bot
                  return ListTile(
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFFEFEFEF), // Color gris claro para el mensaje del bot
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Generando respuesta...",
                                  style: botTextStyle,
                                ),
                                const SizedBox(width: 10),
                                LoadingAnimationWidget.progressiveDots(
                                  color: const Color(0xFF4A4A4A),
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat('HH:mm').format(DateTime
                                .now()), // Muestra la hora de la animación
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                var message = _messages[index];
                if (message.containsKey('user')) {
                  return ListTile(
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFFF5D7DA), // Color rosado claro para el mensaje del usuario
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(message['user']!),
                          ),
                          Text(
                            message['time']!,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return ListTile(
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFFEFEFEF), // Color gris claro para el mensaje del bot
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              message['bot']!,
                              style:
                                  botTextStyle, // Usa el estilo de texto común para el mensaje del bot
                            ),
                          ),
                          Text(
                            message['time']!,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Escribe tu mensaje...',
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Color(0xFFBF0000)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Color(0xFFBF0000)),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: const Color(0xFFBF0000),
                  onPressed: _handleSendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
