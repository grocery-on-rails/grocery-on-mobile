import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/utils/navigation.dart';
import 'package:grocery_on_rails/widgets/big_text_container.dart';
import 'package:grocery_on_rails/widgets/my_form.dart';
import 'package:grocery_on_rails/pages/signup.dart';

class SigninPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: BigTextContainer(
            text: "Sign in",
            children: [
              SizedBox(height: 75),
              MyForm(
                actionText: "SIGN IN",
                hintTexts: LinkedHashMap.from({
                  "Email Address": false,
                  "Password": true
                }),
                onSubmit: (values) async {
                  String errorMessage = await DataManager().signIn(
                    values[0],
                    values[1],
                  );

                  if (errorMessage.isEmpty) {
                    toHome();
                    Navigator.pop(context);
                    return "";
                  }
                  return errorMessage;
                },
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => SignupPage())
                    );
                  },
                  child: Container(
                    child: Text(
                      "or sign up instead"
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}