import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/utils/navigation.dart';
import 'package:grocery_on_rails/widgets/big_text_container.dart';
import 'package:grocery_on_rails/widgets/my_form.dart';
import 'package:grocery_on_rails/pages/signin.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: BigTextContainer(
            text: "Sign up",
            children: [
              SizedBox(height: 75),
              MyForm(
                actionText: "SIGN UP",
                hintTexts: LinkedHashMap.from({
                  "Name": false,
                  "Email Address": false,
                  "Password": true
                }),
                onSubmit: (values) async {
                  String errorMessage = await DataManager().signUp(
                    values[0],
                    values[1],
                    values[2]
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
                      MaterialPageRoute(builder: (context) => SigninPage())
                    );
                  },
                  child: Container(
                    child: Text(
                      "Already have an account?"
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
