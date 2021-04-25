import 'package:flutter/material.dart';
import 'package:grocery_on_rails/pages/cart.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/utils/constants.dart';
import 'package:grocery_on_rails/utils/navigation.dart';
import 'package:grocery_on_rails/pages/home.dart';
import 'package:grocery_on_rails/pages/cat.dart';
import 'package:grocery_on_rails/pages/account.dart';
import 'package:grocery_on_rails/pages/signin.dart';

void main() {
  runApp(MaterialApp(
    title: "Grocery on rails",
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  
  List<Widget> _widgetOptions;

  void initState() {
    super.initState();

    DataManager(); // 

    toHome = () {
      setState(() {
        _selectedIndex = 0;
      });
    };
    
    _widgetOptions = [
      HomePage(data: DataManager().home),
      CatPage(data: DataManager().cat),
      CartPage(),
      AccountPage(),
    ]; 
  }

  void _onItemTapped(int index) {
    if (index == 3 && !DataManager().isSignedIn) {
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => SigninPage())
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kColorGrey,
        unselectedItemColor: Color(0xFF5A5A5A),
        selectedItemColor: Colors.white,

        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
