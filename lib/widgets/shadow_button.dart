import 'package:flutter/material.dart';

class ShadowSquareButton extends StatelessWidget {
  
  final Color color;
  final Widget icon;
  final void Function() onPressed;

  const ShadowSquareButton({
    Key key, this.color, this.icon, this.onPressed 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
          )
        ],
      ),
      child: IconButton(
        icon: this.icon,
        onPressed: this.onPressed,
      ),
    );
  }
}


class ShadowCircularButton extends StatelessWidget {
  
  final Color color;
  final Widget icon;
  final void Function() onPressed;

  const ShadowCircularButton({
    Key key, this.color, this.icon, this.onPressed 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
          )
        ],
      ),
      width: 40,
      child: IconButton(
        icon: this.icon,
        onPressed: this.onPressed,
      ),
    );
  }
}
