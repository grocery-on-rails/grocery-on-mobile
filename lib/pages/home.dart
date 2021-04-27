import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/constants.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/widgets/nested_tab_bar.dart';
import 'package:grocery_on_rails/widgets/product_summary_card.dart';
import 'package:grocery_on_rails/widgets/big_text_container.dart';
import 'package:grocery_on_rails/pages/search.dart';

class HomePage extends StatefulWidget {  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    print('HomePage Build');
    return Stack(
      children: [
        BigTextContainer(
          text: 'Grocery\nOn Rails', 
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFFF9F9F9),
                  // border: Border.all(color: kOrange),
                ),
                height: 50,
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 10),
                    Text(
                      'Java, spaghetti, and more',
                      style: TextStyle(
                        color: Color(0xFFAFAFAF),
                      ),
                    ),
                  ],
                )
              ),
            ),
            FutureBuilder(
              future: DataManager().home,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return NestedTabBar(
                    labels: snapshot.data['labels'] as List<String>,
                    children: (snapshot.data['products'] as List<List<ProductSummary>>).map((l) =>
                      GridView.count(
                        childAspectRatio: 3/4,
                        crossAxisCount: 2,
                        children: l.map((i) => ProductSummaryCard(productSummary: i)).toList(),
                      )
                    ).toList(),
                  );
                }
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator()
                  ),
                );
              },
            ),
          ]
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                DataManager().refreshHome();
              });
            },
            child: const Icon(Icons.refresh, color: Colors.white,),
            backgroundColor: kColorOrange,
          ),
        ),
      ],
    );
  }
}