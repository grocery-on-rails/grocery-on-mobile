import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/utils/constants.dart';
import 'package:grocery_on_rails/pages/product.dart';
import 'package:grocery_on_rails/widgets/quantity_modifier.dart';

class CartCard extends StatelessWidget {

  final String productID;
  final void Function() onPress; // Called when any button is pressed
  
  const CartCard({
    Key key, this.productID, this.onPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!DataManager().cart.map.containsKey(this.productID))
      return Container();

    CartItem c = DataManager().cart.map[this.productID];
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => ProductPage(productSummary: c.productSummary,)),
          ).then((value) {
            this.onPress?.call();
          });
        },
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
              )
            ],
          ),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 2, top: 2, bottom: 2),
                  child: Image(image: c.productSummary.image),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 10,
                            child: Text(
                              c.productSummary.name, 
                              style: kTextStyleProductSummaryMain,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              child: Container(
                                child: Icon(Icons.close, color: kColorOrange,)
                              ),
                              onTap: () {
                                DataManager().cart.remove(c.productSummary);
                                this.onPress?.call();
                              },
                            ),
                          ),
                        ],
                      ),
                      Text("${c.productSummary.price.toStringAsFixed(2)} $kCurrency", 
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QuantityModifier(
                            productID: c.productSummary.id,
                            primaryColor: kColorOrange,
                            secondaryColor: Colors.white,
                            textColor: Colors.black,
                            onPress: () {
                              this.onPress?.call();
                            },
                          ),
                          Text('${(c.productSummary.price * c.quantity).toStringAsFixed(2)} $kCurrency'),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

