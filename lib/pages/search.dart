import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/constants.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/widgets/shadow_button.dart';
import 'package:grocery_on_rails/widgets/product_summary_card.dart';

class SearchPage extends StatefulWidget {

  final String cat;

  SearchPage({Key key, this.cat}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

// redesign
class _SearchPageState extends State<SearchPage> {
  List<Widget> searchItems = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ShadowSquareButton(
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back, color: kColorOrange),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: SearchBar(
                          hintText: this.widget.cat ?? 'Java, spaghetti, and more',
                          onSubmitted: (String value) async {
                            // TODO: new widget
                            this.searchItems = (await searchProduct(value)).map((i) => ProductSummaryCard(productSummary: i)).toList();
                            setState(() {
                              
                            });
                          },
                        ),
                      ),
                    ]               
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: GridView.count(
                      childAspectRatio: 2/3,
                      crossAxisCount: 2,
                      children: this.searchItems,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final String hintText;
  final Function(String) onSubmitted;

  const SearchBar({
    this.hintText,
    this.onSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: this.onSubmitted,
      textInputAction: TextInputAction.search,
      autofocus: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 17.5, horizontal: 15),

        filled: true,
        fillColor: Color(0xFFF9F9F9),

        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kColorOrange),
          borderRadius: BorderRadius.circular(15),
        ),
        
        hintText: this.hintText,
        hintStyle: TextStyle(
          color: Color(0xFFAFAFAF),
          fontSize: 14
        ),
        prefixIcon: Icon(Icons.search, color: Colors.black),
      ),
    );
  }
}