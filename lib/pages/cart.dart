import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/widgets/big_text_container.dart';
import 'package:grocery_on_rails/widgets/cart_card.dart';
import 'package:grocery_on_rails/widgets/rounded_button.dart';
import 'package:grocery_on_rails/pages/signin.dart';


class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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

                // TODO
              },
            ),
          ),
        ),
      ],
    );
  }
}