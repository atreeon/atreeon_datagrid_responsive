import 'package:flutter/material.dart';

class TextEditingControllerExample extends StatefulWidget {
  const TextEditingControllerExample({Key? key}) : super(key: key);
  _TextEditingControllerExampleState createState() => _TextEditingControllerExampleState();
}

class _TextEditingControllerExampleState extends State<TextEditingControllerExample> {
  final TextEditingController _controller = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: TextFormField(
        controller: _controller,
      ),
    );
  }
}
