import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/constants.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/widgets/big_text_container.dart';
import 'package:grocery_on_rails/widgets/cart_card.dart';
import 'package:grocery_on_rails/widgets/edit_screen.dart';
import 'package:grocery_on_rails/widgets/my_form.dart';
import 'package:grocery_on_rails/widgets/my_radio_form.dart';
import 'package:grocery_on_rails/widgets/rounded_button.dart';
import 'package:grocery_on_rails/pages/signin.dart';
import 'package:grocery_on_rails/pages/orders.dart';


class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  
  void viewSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Order Successfully Placed!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        action: SnackBarAction(
          label: 'View Orders',
          textColor: kColorOrange,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrdersPage()),
            );
          },
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BigTextContainer(
      text: "Cart",
      children: [
        Expanded(
          child: FutureBuilder(
            future: DataManager().cart.isLoaded,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (DataManager().cart.map.isEmpty)
                  return Text("The cart is empty, add some products your cart!");
                return ListView(
                  padding: EdgeInsets.all(6),
                  children: [
                    for (CartItem a in DataManager().cart.map.values)
                      CartCard(
                        productID: a.productSummary.id,
                        onPress: () {
                          setState(() {});
                        },
                      ),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator()
              );
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5, top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total amount:",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16
                ),
              ),
              Text(DataManager().cart.total.toStringAsFixed(2),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Opacity(
            opacity: DataManager().cart.map.isEmpty ? 100/256 : 1,
            child: BigRoundedButton(
              "CHECK OUT",
              onPress: (){

                if (DataManager().cart.map.isEmpty)
                  return;

                if (!DataManager().isSignedIn) {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => SigninPage())
                  );
                  return;
                }

                EditScreen(
                  context: context,
                  title: "Select Address",
                  form: MyRadioForm(
                    actionText: "SELECT",
                    labelTexts: DataManager().settings.addresses,
                    onSubmit: (address) {
                      Navigator.pop(context);
                      
                      EditScreen(
                        context: context,
                        title: "Payment",
                        form: MyForm(
                          actionText: "PAY",
                          hintTexts: LinkedHashMap.from({
                            "Name on card": false,
                            "Card number": false,
                            "Expiry Date MM/YY": false,
                            "CVV": true
                          }),
                          onSubmit: (values) async {

                            // format validation
                            if (RegExp(r'^\s*$').hasMatch(values[0]))
                              return "Input a valid name";

                            if (!RegExp(r'^\d{16}$').hasMatch(values[1].replaceAll(' ', '')))
                              return "Card number incorrect";

                            if (!RegExp(r'^\d{1,2}\/\d{2}$').hasMatch(values[2].replaceAll(' ', '')))
                              return "Expiry data incorrect";
                            
                            if (!RegExp(r'^\d{3,4}$').hasMatch(values[3].replaceAll(' ', '')))
                              return "CVV incorrect";


                            // Requests
                            await DataManager().order(address, values[0]);
                            
                            setState(() {
                              Navigator.pop(context);
                            });

                            viewSnackBar();

                            return "";
                          },
                        ),
                      );
                    },
                  ),
                );

              },
            ),
          ),
        ),
      ],
    );
  }
}