import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/constants.dart';

class BigTextContainer extends StatelessWidget {
  
  final String text;
  final List<Widget> children;

  BigTextContainer({
    @required this.text,
    @required this.children,
    key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                this.text,
                style: kTextStyleBig,
              ),
            ),
            ...this.children,
          ],
        ),
      ),
    );
  }
}