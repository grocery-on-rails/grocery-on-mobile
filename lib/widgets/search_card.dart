import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/utils/constants.dart';
import 'package:grocery_on_rails/pages/product.dart';

class SearchCard extends StatelessWidget {

  final ProductSummary productSummary;
  final String textMain;
  final String textSub;
  
  SearchCard(ProductSummary productSummary) : 
    productSummary = productSummary,
    textMain = productSummary.name.toString(),
    textSub = "${productSummary.price.toStringAsFixed(2)} $kCurrency";

  SearchCard.fromCartItem(CartItem c) :
    productSummary = c.productSummary,
    textMain = c.productSummary.name.toString(),
    textSub = "${c.productSummary.price.toStringAsFixed(2)} $kCurrency (x${c.quantity}) = ${(c.productSummary.price*c.quantity).toStringAsFixed(2)} $kCurrency";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => ProductPage(productSummary: productSummary,)),
          );
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
                  padding: const EdgeInsets.only(left: 5, top: 2, bottom: 2),
                  child: Image(image: this.productSummary.image),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10, bottom: 40, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        textMain, 
                        style: kTextStyleProductSummaryMain,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        textSub,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
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

