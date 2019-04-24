import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

const String _name =
    "John Appleseed"; // Value hard-coded for educational purposes

void main() {
  runApp(new FriendlychatApp());
}

// Two ThemeData, one for each platform
final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendlychat",
      theme: defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // To use your ChatScreenState as the vsync, include a TickerProviderStateMixin mixin in the ChatScreenState class definition.
  // To manage interactions with the Text Field, it's helpful to use a 'TextEditingController' object.
  // You'll use it for reading the contents of the input field, and for clearing the field after the text message is sent.
  final TextEditingController _textController = new TextEditingController();

  //List member to represent each chat message. Each item is a ChatMessage instance. You need to initialize the message list ot an empty List.
  final List<ChatMessage> _messages = <ChatMessage>[];

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Friendlychat"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        /*
        We can apply the selected theme to the AppBar widget (the banner at the top of your app's UI). The elevation property defines the z-coordinates of the AppBar.
        A z-coordinate value of 0.0 has no shadow (iOS) and a value of 4.0 has a defined shadow (Android).
         */
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Flexible(
              // This tells the framework to let the list of messages expand to fill the Column height while TextField remains a fixed size.
              child: new ListView.builder(
                //We choose the ListView.builder constructor because the default constructor doesn't automatically detect mutations of its children argument.
                padding: new EdgeInsets.all(
                    8.0), // For white space around the message list
                reverse:
                    true, // to make the ListView start from the bottom of the screen
                itemBuilder: (_, int index) => _messages[
                    index], //itemBuilder for a function that builds each widget in [index]. Since we don't need the current build context, we can ignore the first argument of IndexedWidgetBuilder (convention: _)
                itemCount: _messages
                    .length, // to specify the number of messages in the list
              ),
            ),
            new Divider(
                height:
                    1.0), // To draw a horizontal rule between the UI for displaying messages and the text input field for composing messages.
            new Container(
              // Container as a parent of the text composer. It's useful to define background images, padding, margins and another common layout details.
              decoration: new BoxDecoration(
                  // Use decoration to create a new BoxDecoration object that defines the background.
                  color: Theme.of(context).cardColor),
              child:
                  _buildTextComposer(), // Tells the app how to display the text input user control,
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS ? new BoxDecoration(
          border: new Border(
            top: new BorderSide(
              color: Colors.grey[200]
            )
          )
        )
            : null
      ),
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
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted:
                    _handleSummited, // To be notified when the user submits a message; provice a private callback method.
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS ?
                  new CupertinoButton(
                      child: new Text('Send'),
                      onPressed: _isComposing ? () => _handleSummited(_textController.text) : null
                  ) :
              new IconButton(
                icon: new Icon(Icons
                    .send), // The color of the button is black, from the default Material Design Theme. To give the icons in your app an accent color, pass the color argument to IconButton. Alternatively, you can apply a different theme.
                onPressed: _isComposing ? () => _handleSummited(_textController.text) : null, // Fat Arrow Function Declaration, shorthand of Dart
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
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
      // In this method, instantiate an AnimationController object and specify the animation's duration runtime. Attach the animation to a new ChatMessage instance ...
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 100),
        /*
        When creating an AnimationController, you must pass it a vsync argument. The vsync prevents animations that are offscreen from consuming unnecessary resources. 
        To use your ChatScreenState as the vsync, include a TickerProviderStateMixin mixin in the ChatScreenState class definition.
        */
        vsync: this,
      ),
    );
    // You call setState() to modify _messages and let the framework kwno this part of the widget tree has changed and it needs to rebuild de UI.
    // Only synchronous operations should be performed in setState(), because otherwise the framework could rebuild the widgets before the operation finishes.
    /*
    In general, it is possible to call setState() with an empty closure after some private data changed outside of this method call. 
    However, updating data inside setState()'s closure is preferred, so you don't forget to call it afterwards.
    */
    setState(() {
      _messages.insert(0, message);
    });
    // Specify that the animation should play forward whenever is added to the chat list.
    message.animationController.forward();
  }

  /*
  It's good practice to dispose of your animation controllers to free up your resources when they are no longer needed. The following code snippet shows how you can implement this operation by overriding the dispose() method in ChatScreenState. 
  In the current app, the framework does not call the dispose()method since the app only has a single screen. 
  In a more complex app with multiple screens, the framework would invoke the method when the ChatScreenState object was no longer in use.
  */
  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.text,
      this.animationController}); // Constructor, added animationController
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    // Modify the ChatMessage object's build() method to return a SizeTransition widget that wraps the Container child widget.
    // The SizeTransition class provides an animation effect where the width or heigth of its childs is multiplied by a given size factor value.
    // The CurvedAnimation object, in conjunction with the SizeTransition class, produces an ease-out animation effect.
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          // Using CrossAxisAlignment.start as the crossAxisAlignment argumento of the Row constructor to position the avatar and messages relative to their parent widget.
          // For the avatar, the parent is Row iwdget whose main axis is horizontal, so CrossAxisAlignment.start gives it the highest position alogn the vertical axis.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
            /*
            Expanded allows a widget like Column to impose layout constraints (in this case the Column's width), on a child widget.
            Here it constrains the width of the Text widget, which is normally determined by its contents.
             */
            new Expanded(
                child: new Column(
                  // For messages, the parent is a Colum widget whose main axis is vertical, so CrossAxisAlignment.start aligns the text at the furthest left position along the horizontal axis.
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align two Text widgets vertically to display the sender's name on top and the text of the message below.
                  children: <Widget>[
                    new Text(_name,
                        style: Theme.of(context)
                            .textTheme
                            .subhead), // Style sender's name and make it larger that the message text
                    // Theme.of(context) obtains an appropiate ThemeData object.
                    // If you havent's specified a theme for this app Theme.of(context) will retrieve the default Flutter theme.
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
