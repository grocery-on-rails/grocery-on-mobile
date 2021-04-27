import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/constants.dart';

class RoundedButton extends StatelessWidget {

  final void Function() onPress;
  final List<Widget> children;
  final double height;
  final Color backgroundColor;

  const RoundedButton({
    Key key,
    @required this.children,
    this.onPress,
    this.backgroundColor = kColorOrange,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.onPress?.call();
      },
      child: Container(
        height: this.height,
        decoration: BoxDecoration(
          color: this.backgroundColor,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: this.children,
          ),
        ),
      ),
    );
  }
}

class BigRoundedButton extends StatelessWidget {
  
  final String text;
  final void Function() onPress;
  
  const BigRoundedButton(this.text, {
    Key key, this.onPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      onPress: this.onPress,
      children: [
        Text(
          this.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),
        ),
      ],
      height: 50,
    );
  }
}