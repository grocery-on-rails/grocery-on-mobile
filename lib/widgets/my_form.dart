import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:grocery_on_rails/widgets/rounded_button.dart';
import 'package:grocery_on_rails/widgets/input_box.dart';

class MyForm extends StatefulWidget {
  
  final String actionText;
  final LinkedHashMap<String, bool> hintTexts; // (hintText, isPassword)
  final List<String> initalTexts;
  final Future<String> Function(List<String>) onSubmit; // return error message, "" if no error

  MyForm({ Key key, this.actionText, this.hintTexts, this.onSubmit, this.initalTexts }) : super(key: key);

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {

  List<InputBox> inputBoxes = [];

  bool isDisabled = false;
  String errorMessage;

  void submit() {
    setState(() {
      FocusScope.of(context).unfocus();
      isDisabled = true;
    });

    this.widget.onSubmit(
      inputBoxes.map((e) => e.text).toList()
    ).then((errorMessage) {

      setState(() {
        isDisabled = false;
        this.errorMessage = errorMessage;
      });
      
    });
  }

  @override
  void initState() {
    super.initState();

    List<String> hintTextList = this.widget.hintTexts.keys.toList().reversed.toList();

    if (hintTextList.length > 0)
      inputBoxes.add(
        InputBox(
          hintText: hintTextList[0],
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            submit();
          },
          isPassword: this.widget.hintTexts[hintTextList[0]],
        )
      );

    for (String s in hintTextList.sublist(1)) {
      InputBox lastItem = inputBoxes.last;
      inputBoxes.add(
        InputBox(
          hintText: s,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) {
            lastItem.requestFocus();
          },
          isPassword: this.widget.hintTexts[s],
        )
      );
    }


    inputBoxes = inputBoxes.reversed.toList();


    this.widget.initalTexts?.asMap()?.forEach((index, value) {
      inputBoxes[index].text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: Column(
        children: [
          for (InputBox ib in this.inputBoxes) ...[
            ib, SizedBox(height: 15),
          ],
          Text(this.errorMessage ?? "",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          SizedBox(height: 15),
          Opacity(
            opacity: isDisabled ? 100/256 : 1,
            child: BigRoundedButton(
              this.widget.actionText,
              onPress: submit,
            ),
          ),
        ],
      ),
    );
  }
}

