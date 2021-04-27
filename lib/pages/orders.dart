import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/constants.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/widgets/big_text_container.dart';
import 'package:grocery_on_rails/widgets/search_card.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: BigTextContainer(
            text: "Orders",
            children: [
              Expanded(
                child: FutureBuilder(
                  future: DataManager().orders(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data.isEmpty)
                        return Text("The order list is empty, order first!");
                      return ListView(
                        padding: EdgeInsets.all(6),
                        children: [
                          for (Order a in snapshot.data)
                            OrderCard(order: a),
                        ],
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator()
                    );
                  }
                ),
              ),
            ],
          )
        )
      )
    );
  }
}

class OrderCard extends StatelessWidget {

  final Order order;

  OrderCard({Order order}) :
    order = order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 10, top: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order №${order.orderTime.millisecondsSinceEpoch.toString().substring(0, 10)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${order.orderTime.day}/${order.orderTime.month}/${order.orderTime.year}",                 
                  style: TextStyle(
                    color: kColorOrange,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            Row(
              children: [
                Text("Address: ", style: kTextStyleWhite,),
                Text(order.address, style: kTextStyleWhiteBold,),
              ],
            ),
            SizedBox(height: 10),

            Row(
              children: [
                Text("Payment Method: ", style: kTextStyleWhite,),
                Text(order.getPaymentObfuscated(), style: kTextStyleWhiteBold,),
              ],
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Row(
                  children: [
                    Text("Total Amount: ", style: kTextStyleWhite,),
                    Text("${order.cart.total.toStringAsFixed(2)} $kCurrency", style: kTextStyleWhiteBold,),
                  ],
                ),
                Text("${order.status.toUpperCase()}", 
                  style: TextStyle(
                    color: kColorOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            for (CartItem c in order.cart)
              Padding(
                padding: const EdgeInsets.only(left: 35),
                child: SearchCard.fromCartItem(c),
              ),
          ]
        )
      ),
    );
  }
}