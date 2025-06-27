import 'package:flutter/material.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart'; // Hypothetical package

class HelpChatScreen extends StatefulWidget {
  const HelpChatScreen({Key? key}) : super(key: key);

  @override
  _HelpChatScreenState createState() => _HelpChatScreenState();
}

class _HelpChatScreenState extends State<HelpChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  final Dialogflow _dialogflow = Dialogflow(); // Hypothetical

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;
    setState(() => _messages.add('You: $message'));
    try {
      final response = await _dialogflow.sendQuery(message);
      setState(() {
        _messages.add('Bot: ${response.text ?? 'No response'}');
      });
    } catch (e) {
      setState(() {
        _messages.add('Bot: Error: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _messages.map((msg) => ListTile(title: Text(msg))).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type your query...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
