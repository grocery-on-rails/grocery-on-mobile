import 'package:flutter/material.dart';
import 'package:grocery_on_rails/pages/search.dart';


class SmolButton extends StatelessWidget {
  final String text;
  final Function() onPress;

  SmolButton({this.text, this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
            child: Text(
              this.text,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CatRowList extends StatelessWidget {
  final List<String> data;

  CatRowList({this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List<Widget>.from(data.map((e) => SmolButton(
          text: e.toLowerCase(),
          onPress: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => SearchPage(cat: e)),
            );
          },
        ))),
      )
    );
  }
}