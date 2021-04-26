import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/constants.dart';

class InputBox extends StatelessWidget {
  
  final String hintText;
  final TextInputAction textInputAction;
  final void Function(String) onSubmitted;
  final bool isPassword;

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  String get text => _textEditingController.text;
  set text(String value) {
    _textEditingController.text = value;
  }

  void requestFocus() {
    _focusNode.requestFocus();
  }

  
  InputBox({
    Key key,
    this.hintText,
    this.textInputAction,
    this.onSubmitted,
    this.isPassword = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
          )
        ],
      ),
      child: TextField(
        controller: this._textEditingController,
        focusNode: this._focusNode,

        textInputAction: this.textInputAction,
        onSubmitted: this.onSubmitted,
        obscureText: this.isPassword,

        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 17.5, horizontal: 15),

          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kColorOrange),
            borderRadius: BorderRadius.circular(15),
          ),
          
          hintText: this.hintText,
          hintStyle: TextStyle(
            color: Color(0xFFAFAFAF),
            fontSize: 14
          ),
        ),
      ),
    );
  }
}