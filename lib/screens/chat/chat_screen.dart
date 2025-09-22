
import 'package:flutter/material.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');

  void _sendMessage() async {
    final message = _messageController.text;
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'message': message});
    });

    _messageController.clear();

    try {
      final response = await model.generateContent([Content.text(message)]);

      setState(() {
        _messages.add({'role': 'assistant', 'message': response.text ?? ''});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'assistant', 'message': 'Error: ${e.toString()}'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Assistant'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message['message']!),
                  leading: message['role'] == 'user'
                      ? const Icon(Icons.person)
                      : const Icon(Icons.assistant),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ask a question...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
