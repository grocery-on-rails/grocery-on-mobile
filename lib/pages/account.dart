import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/utils/navigation.dart';
import 'package:grocery_on_rails/widgets/big_text_container.dart';
import 'package:grocery_on_rails/widgets/rounded_button.dart';

class AccountPage extends StatefulWidget {

  AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return BigTextContainer(
      text: "Account" + DataManager().settings.email,
      children: [
        BigRoundedButton(
          "Log Out",
          onPress: () {
            DataManager().signOut();
            toHome();
          },
        )
      ],
    );
  }
}