import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'coupon_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_message_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thank You App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CouponListScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mail_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('Thank You Messages'),
          ],
        ),
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
      body: MessageListView(),
      floatingActionButton: Container(
        width: 320.0,
        height: 60.0,
        margin: EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateMessageScreen()),
            );
          },
          label: Text('Create New Appreciation Message'),
          icon: Icon(Icons.add),
          backgroundColor: Colors.transparent,
          elevation: 4.0,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class MessageListView extends StatefulWidget {
  @override
  _MessageListViewState createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  List<bool> _isExpanded = List<bool>.generate(10, (index) => false);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: 10, // 仮のデータ数
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          color: Colors.primaries[index % Colors.primaries.length].shade100,
          child: ExpansionTile(
            leading: Icon(Icons.mail_outline, color: Colors.blue),
            title: Text('Thank you message $index'),
            subtitle: Text(
              'This is a sample thank you message. This is a sample thank you message. This is a sample thank you message. This is a sample thank you message.',
              maxLines: _isExpanded[index] ? null : 1,
              overflow: _isExpanded[index] ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isExpanded[index] = expanded;
              });
            },
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'This is a sample thank you message. This is a sample thank you message. This is a sample thank you message. This is a sample thank you message. This is a sample thank you message.',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CreateMessageScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Write your thank you message below:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter your thank you message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    FirebaseFirestore.instance.collection('messages').add({
                      'message': _controller.text,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Message Sent!')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a message')),
                    );
                  }
                },
                child: Text('Send'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}