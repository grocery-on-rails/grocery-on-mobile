import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/constants.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/widgets/shadow_button.dart';
import 'package:grocery_on_rails/widgets/search_card.dart';
import 'package:grocery_on_rails/widgets/edit_screen.dart';
import 'package:grocery_on_rails/widgets/my_radio_form.dart';

class SearchPage extends StatefulWidget {

  final String cat;

  SearchPage({Key key, this.cat}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

// redesign
class _SearchPageState extends State<SearchPage> {
  
  List<Widget> searchItems = [];

  String keyword = '';
  SortingType sort = SortingType.Relevance;
  String category = '';

  @override
  void initState() {
    super.initState();

    this.category = (this.widget.cat ?? '');
    if (this.category != '')
      search();
  }

  void search() async {
    if (keyword == '' && category == '')
      return;
    searchItems = null;
    setState(() {});
    this.searchItems = (await searchProduct(
      keyword,
      sort: sort,
      subcategory: category
    )).map((i) => SearchCard(i)).toList();
    setState(() {});
  }

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
                  Container(
                    child: Row(
                      children: [
                        ShadowSquareButton(
                          color: Colors.white,
                          icon: Icon(Icons.arrow_back, color: kColorOrange),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: SearchBar(
                            hintText: 'Java, spaghetti, and more',
                            onSubmitted: (String value) async {
                              this.keyword = value;
                              search();
                            },
                          ),
                        ),
                        SizedBox(width: 5),
                        ShadowSquareButton(
                          color: Colors.white,
                          icon: Icon(this.sort.icon, color: kColorOrange),
                          onPressed: () {

                            EditScreen(
                              context: context,
                              title: "Pick Sorting Option",
                              form: MyRadioForm(
                                actionText: "SELECT",
                                labelTexts: [
                                  SortingType.Relevance.displayText,
                                  SortingType.PriceLowToHigh.displayText,
                                  SortingType.PriceHighToLow.displayText,
                                ],
                                initialValue: (this.sort.displayText == '' ? null : this.sort.displayText),
                                onSubmit: (value) {

                                  this.sort = sortingTypeFromDisplayText(value);
                                  search();                                  

                                  Navigator.pop(context);

                                }
                              ),
                            );

                          },
                        ),
                        SizedBox(width: 5),
                        ShadowSquareButton(
                          color: this.category == '' ? Colors.white : kColorOrange,
                          icon: Icon(Icons.filter_alt_outlined, color: this.category == '' ? kColorOrange : Colors.white),
                          onPressed: () {

                            if (this.category != '') {
                              setState(() {
                                this.category = '';
                              });
                              search();
                              return;
                            }

                            EditScreen(
                              context: context,
                              title: "Pick Category",
                              form: FutureBuilder(
                                future: DataManager().cat,
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                      List<String> labels = List<String>.from(snapshot.data.values.toList().expand((i) => List<String>.from(i)).toSet());
                                      labels.sort();
                                      return MyRadioForm(
                                        actionText: "SELECT",
                                        labelTexts: labels,
                                        initialValue: (this.category == '' ? null : this.category),
                                        onSubmit: (value) {

                                          this.category = value;
                                          search();       

                                          Navigator.pop(context);

                                        }
                                    );
                                  }
                                  return Center(
                                    child: CircularProgressIndicator()
                                  ); 
                                }
                              )
                            );
                            
                          },
                        ),
                      ]               
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (searchItems == null)
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator()
                      ),
                    ),
                  if (searchItems?.length == 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("No search results")
                      ),
                    ),
                  if (!(searchItems == null || searchItems.length == 0))
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(6),
                        children: this.searchItems,
                      )
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