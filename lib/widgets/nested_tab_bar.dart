import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/constants.dart';

class NestedTabBar extends StatefulWidget {

  final List<String> labels;
  final List<Widget> children;

  NestedTabBar({Key key, this.labels, this.children}) : 
    assert(labels.length == children.length), 
    super(key: key);

  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar> with TickerProviderStateMixin {
  
  TabController _nestedTabController;

  @override
  void initState() {
    print('Nested Tab Bar init');
    super.initState();
    _nestedTabController = new TabController(length: this.widget.labels.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          TabBar(
            controller: _nestedTabController,
            isScrollable: true,

            indicatorColor: kColorOrange,
            indicatorSize: TabBarIndicatorSize.label,

            labelColor: Colors.black,  
            labelStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),

            tabs: this.widget.labels.map((e) => Tab(text: e)).toList(),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: TabBarView(
              controller: _nestedTabController,
              children: this.widget.children
            ),
          )
        ],
      ),
    );
  }
}
