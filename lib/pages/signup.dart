import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/utils/navigation.dart';
import 'package:grocery_on_rails/widgets/big_text_container.dart';
import 'package:grocery_on_rails/widgets/rounded_button.dart';
import 'package:grocery_on_rails/widgets/input_box.dart';
import 'package:grocery_on_rails/pages/signin.dart';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isDisabled = false;
  String errorMessage;

  InputBox inputPassword;
  InputBox inputEmail;
  InputBox inputName;

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
    inputName = InputBox(
      hintText: "Name",
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        inputEmail.requestFocus();
      },
    );
  }

  void submit() {
    setState(() {
      FocusScope.of(context).unfocus();
      _isDisabled = true;
    });

    DataManager().signUp(
      inputName.text,
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
              text: "Sign up",
              children: [
                SizedBox(height: 75),
                inputName, SizedBox(height: 15),
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
                    "SIGN UP",
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
            ),
          ),
        ),
      ),
    );
  }
}

