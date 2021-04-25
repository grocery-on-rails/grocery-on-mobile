import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/constants.dart';
import 'package:grocery_on_rails/utils/strings.dart';
import 'package:grocery_on_rails/widgets/big_text_container.dart';
import 'package:grocery_on_rails/pages/search.dart';

class CatPage extends StatelessWidget {
  
  final Future<Map<String, List<String>>> data;
  
  CatPage({this.data});

  @override
  Widget build(BuildContext context) {
    return BigTextContainer(
      text: 'Categories', 
      children: [
        Text("Choose Category",
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Expanded(
          child: FutureBuilder(
            future: data,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    for (String key in snapshot.data.keys)
                      Theme(
                        data: ThemeData(
                          accentColor: kColorOrange,
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          title: Text(key),
                          childrenPadding: EdgeInsets.only(left: 20),
                          children: [
                            for (String category in snapshot.data[key])
                              ListTile(
                                title: Text(category.toLowerCase().toCamelCase()),
                                enabled: true,
                                onTap: () {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => SearchPage(cat: category)),
                                  );
                                },
                              ),
                          ],
                        ),
                      )
                  ],
                );
              }
              return Expanded(
                child: Center(
                  child: CircularProgressIndicator()
                ),
              );
            },
          ),
        ),
      ]
    );
  }
}