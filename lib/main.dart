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
      body:
          _buildTextComposer(), // Tells the app how to display the text input user control
    );
  }

  // The following code shows how you can define a private method called '_buildTextComposer()' that returns a 'Container'
  // widget with a configured 'TextField' widget.
  Widget _buildTextComposer() {
    return new IconTheme(
      // Icons inherit their color, oppacity and size from an 'IconTheme' widget, which uses an IconThemeData object to define their characteristics.
      /*
      Note from tutorial author:
      A BuildContext object is a handle to the location of a widget in your app's widget tree. 
      Each widget has its own BuildContext, which becomes the parent of the widget returned by the StatelessWidget.build or State.build function. 
      This means the _buildTextComposer() method can access the BuildContext object from its encapsulating State object; 
      you don't need to pass the context to the method explicitly.
      */
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(
            horizontal:
                8.0), // Adds a horizontal margin between the edge of the screen and each side of the input field.
        // Unit: Logical pixel that get translated into a specific number of physical pixels, depending on a device's pixel ratio.
        child: new Row(
          // To add a button on the right, wrap everything on a Row
          children: <Widget>[
            new Flexible(
              // Wrap the textfield in a Flexible widget. This tells the Row to automatically size the text field to use the ramining space that isn't used by the button.
              child: new TextField(
                controller:
                    _textController, // we provide the 'TextField' constructor with a 'TextEditingController'
                onSubmitted:
                    _handleSummited, // To be notified when the user submits a message; provice a private callback method.
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons
                    .send), // The color of the button is black, from the default Material Design Theme. To give the icons in your app an accent color, pass the color argument to IconButton. Alternatively, you can apply a different theme.
                onPressed: () => _handleSummited(_textController
                    .text), // Fat Arrow Function Declaration, shorthand of Dart
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Prefixing an identifier with an _(underscore) makes it private to its class.
  void _handleSummited(String text) {
    _textController.clear(); // For now, just clear the field.
  }
}
