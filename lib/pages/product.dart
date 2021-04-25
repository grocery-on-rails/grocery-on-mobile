import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/utils/constants.dart';
import 'package:grocery_on_rails/widgets/categories_row_list.dart';
import 'package:grocery_on_rails/widgets/quantity_modifier.dart';
import 'package:grocery_on_rails/widgets/shadow_button.dart';
import 'package:grocery_on_rails/widgets/rounded_button.dart';

class ProductPage extends StatefulWidget {
  
  final ProductSummary productSummary;

  ProductPage({Key key, this.productSummary}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: Container(
          height: 60,
          color: kColorGrey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${this.widget.productSummary.price.toStringAsFixed(2)} $kCurrency',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                
                if (DataManager().cart.map.containsKey(this.widget.productSummary.id))
                  QuantityModifier(
                    productID: this.widget.productSummary.id,
                    primaryColor: Colors.white,
                    secondaryColor: kColorOrange,
                    textColor: Colors.white,
                    onPress: () {
                      setState(() {});
                    },
                  ),
                
                if (!DataManager().cart.map.containsKey(this.widget.productSummary.id))
                  RoundedButton(
                    onPress: () {
                      setState(() {
                        DataManager().cart.increment(this.widget.productSummary);
                      });
                    },
                    children: [
                      Icon(Icons.shopping_bag, color: Colors.white),
                      SizedBox(width: 5,),
                      Text(
                        "Add to Cart",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5,),
                    ],
                  ),

              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShadowSquareButton(
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back, color: kColorOrange),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    ShadowSquareButton(
                      color: kColorOrange,
                      icon: Icon(Icons.shopping_bag, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          DataManager().cart.increment(this.widget.productSummary);
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: Product.fromID(this.widget.productSummary.id, DataManager().headers),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData)
                      return ProductPageContent(product: snapshot.data);
                    return Expanded(child: Center(child: CircularProgressIndicator()));
                  }
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}

class ProductPageContent extends StatelessWidget {
  final Product product;

  const ProductPageContent({
    Key key, this.product
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              product.name,
              style: kTextStyleBig,
            ),
            CatRowList(data: product.subcategories),
            SizedBox(
              height: MediaQuery.of(context).size.height * (1/3),
              child: Image(image: product.image), // TODO: update later to be a gallary
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Product Information",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(product.information,
                  style: TextStyle(
                    fontFamily: 'monaco'
                  ),
                ),
                if (product.description.isNotEmpty)
                  ...[
                    SizedBox(height: 20),
                    Text(
                      "Product Description",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(product.description),
                  ],
              ]
            ),
          ],
        ),
      ),
    );
  }
}

