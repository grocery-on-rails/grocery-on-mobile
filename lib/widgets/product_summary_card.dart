import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/utils/constants.dart';
import 'package:grocery_on_rails/pages/product.dart';


class ProductSummaryCard extends StatelessWidget {
  final ProductSummary productSummary;

  const ProductSummaryCard({Key key, @required this.productSummary}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => ProductPage(productSummary: productSummary,)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 0.5)
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Image(image: productSummary.image)]
                ),
                flex: 3,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text(
                      productSummary.name,
                      overflow: TextOverflow.ellipsis,
                      style: kTextStyleProductSummaryMain,
                    ),
                    Text(
                      '${productSummary.price.toStringAsFixed(2)} $kCurrency',
                      style: kTextStyleProductSummaryPrice,
                    ),
                    if (productSummary.oldPrice != 0)
                      Text(
                        '${productSummary.oldPrice.toStringAsFixed(2)} $kCurrency',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}