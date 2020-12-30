import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'nm_box.dart';

class StaticText extends StatelessWidget {
  final text;
  StaticText(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Text(this.text),
        ),
      ),
    );
  }
}

class TextBox extends StatefulWidget {
  Function validationFunction;
  final textController;
  final obscureText;
  final hintText;
  final key;
  bool readOnly;
  bool isEnabled;
  TextBox(
      {this.key,
      this.validationFunction,
      this.textController,
      this.obscureText = false,
      this.hintText,
      this.readOnly = false,
      this.isEnabled = true});
  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: createInvertBox(),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autocorrect: false,
            key: widget.key,
            obscureText: widget.obscureText,
            readOnly: widget.readOnly,
            enabled: widget.isEnabled,
            validator: widget.validationFunction,
            controller: widget.textController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  VoidCallback onPressed;
  final text;
  Button({this.onPressed, this.text});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.deepOrange,
      splashColor: Colors.orange,
      shape: const StadiumBorder(),
      onPressed: this.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 30.0,
        ),
        child: Container(
          child: Text(
            this.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
