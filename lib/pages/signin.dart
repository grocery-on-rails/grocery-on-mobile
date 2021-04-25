import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/utils/navigation.dart';
import 'package:grocery_on_rails/widgets/big_text_container.dart';
import 'package:grocery_on_rails/widgets/rounded_button.dart';
import 'package:grocery_on_rails/widgets/input_box.dart';
import 'package:grocery_on_rails/pages/signup.dart';


class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool _isDisabled = false;
  String errorMessage;

  InputBox inputPassword;
  InputBox inputEmail;

  @override
  void initState() {
    super.initState();

    inputPassword = InputBox(
      hintText: "Password",
      textInputAction: TextInputAction.done,
      isPassword: true,
      onSubmitted: (_) {
        submit();
      },
    );
    inputEmail = InputBox(
      hintText: "Email Address",
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        inputPassword.requestFocus();
      },
    );

  }

  void submit() {
    setState(() {
      FocusScope.of(context).unfocus();
      _isDisabled = true;
    });

    DataManager().signIn(
      inputEmail.text,
      inputPassword.text
    ).then((response) {

      if (response.isEmpty) {
        toHome();
        Navigator.pop(context);
      }

      setState(() {
        _isDisabled = false;
        errorMessage = response;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: AbsorbPointer(
            absorbing: _isDisabled,
            child: BigTextContainer(
              text: "Sign in",
              children: [
                SizedBox(height: 75),
                inputEmail, SizedBox(height: 15),
                inputPassword, SizedBox(height: 15),
                Text(errorMessage ?? "",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 15),
                Opacity(
                  opacity: _isDisabled ? 100/256 : 1,
                  child: BigRoundedButton(
                    "SIGN IN",
                    onPress: submit,
                  ),
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
            ),
          ),
        ),
      ),
    );
  }
}

