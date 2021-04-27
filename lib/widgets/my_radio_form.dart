import 'package:flutter/material.dart';
import 'package:grocery_on_rails/widgets/rounded_button.dart';

class MyRadioForm extends StatefulWidget {

  final String actionText;
  final List<String> labelTexts;
  final String initialValue;
  final void Function(String) onSubmit;

  MyRadioForm({ Key key, this.actionText, this.labelTexts, this.onSubmit, this.initialValue }) : super(key: key);

  @override
  _MyRadioFormState createState() => _MyRadioFormState();
}

class _MyRadioFormState extends State<MyRadioForm> {
  
  String selectedValue;

  @override
  void initState() {
    super.initState();

    selectedValue = this.widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ListView(
            children: [
              for (String s in this.widget.labelTexts)
                ListTile(
                  title: Text(s),
                  leading: Radio<String>(
                    value: s,
                    groupValue: selectedValue,
                    onChanged: (String value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: 15),
        Opacity(
          opacity: (selectedValue == null) ? 100/256 : 1,
          child: BigRoundedButton(
            this.widget.actionText,
            onPress: () {
              if (selectedValue != null)
                this.widget.onSubmit(selectedValue);
            },
          ),
        ),
      ],
    );
  }
}