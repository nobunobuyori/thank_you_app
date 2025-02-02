import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateMessageScreen extends StatefulWidget {
  @override
  _CreateMessageScreenState createState() => _CreateMessageScreenState();
}

class _CreateMessageScreenState extends State<CreateMessageScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('messages').add({
        'message': _controller.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message sent!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Thank You Message'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your thank you message',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Send',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
