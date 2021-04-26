import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/widgets/big_text_container.dart';

class OrdersPage extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    DataManager().orders().then((value) => print(value));

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: BigTextContainer(
            text: "Orders",
            children: [

            ],
          )
        )
      )
    );
  }
}