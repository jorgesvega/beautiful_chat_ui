import 'package:flutter/material.dart';

void main() {
  runApp(new FriendlychatApp());
}

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendlychat", 
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  // To manage interactions with the Text Field, it's helpful to use a 'TextEditingController' object.
  // You'll use it for reading the contents of the input field, and for clearing the field after the text message is sent.
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Friendlychat"),
      ),
    );
  }

  // The following code shows how you can define a private method called '_buildTextComposer()' that returns a 'Container'
  // widget with a configured 'TextField' widget.
  Widget _buildTextComposer() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0), // Adds a horizontal margin between the edge of the screen and each side of the input field. 
      // Unit: Logical pixel that get translated into a specific number of physical pixels, depending on a device's pixel ratio.
      child: new TextField(
        controller: _textController, // we provide the 'TextField' constructor with a 'TextEditingController'
        onSubmitted: _handleSummited, // To be notified when the user submits a message; provice a private callback method.
        decoration: new InputDecoration.collapsed(
          hintText: "Send a message"),
      ),
    );
  }

  // Prefixing an identifier with an _(underscore) makes it private to its class.
  void _handleSummited(String text) {
    _textController.clear(); // For now, just clear the field.
  }

}
