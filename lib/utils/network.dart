import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;


const theURL = "https://grocery-on-rails.herokuapp.com";
const Map<String, String> contentTypeJSON = {
  'content-type': 'application/json',
};


class CartItem {

  final ProductSummary productSummary;
  int quantity;

  CartItem({@required this.productSummary, @required this.quantity});

}

class Cart {

  final Map<String, String> headers;

  Map<String, CartItem> map = {};
  Future<void> isLoaded;

  Cart({this.headers}) {
    isLoaded = _load();
  }

  Future<void> _load() async {
    if (headers.isNotEmpty) {
      final response = await http.get(
        Uri.parse('$theURL/cart'),
        headers: this.headers,
      );
      final responseJson = jsonDecode(response.body);

      for (dynamic i in responseJson) {
        ProductSummary ps = ProductSummary.fromJSON(i["product_summary"]);
        map[ps.id] = CartItem(productSummary: ps, quantity: i["quantity"]);
      }
    }
  }
  
  void _update(CartItem c) async {
    if (headers.isNotEmpty) {
      await http.post(
        Uri.parse('$theURL/cart'),
        headers: {
          ...this.headers,
          ...contentTypeJSON
        },
        body: jsonEncode({
          "product_id": c.productSummary.id,
          "quantity": c.quantity,
        }),
      );
    }
  }

  void increment(ProductSummary p) {
    if (!map.containsKey(p.id))
      map[p.id] = CartItem(productSummary: p, quantity: 0);

    map[p.id].quantity++;

    _update(map[p.id]);
  }

  void decrement(ProductSummary p) {
    if (map.containsKey(p.id)) {
      map[p.id].quantity--;

      _update(map[p.id]);

      if (map[p.id].quantity == 0)
        map.remove(p.id);
    }
  }

  void remove(ProductSummary p) {
    if (map.containsKey(p.id)) {
      map[p.id].quantity = 0;

      _update(map[p.id]);

      map.remove(p.id);
    }
  }

  double get total {
    double _total = 0;
    for (CartItem c in map.values)
      _total += c.productSummary.price * c.quantity;
    return _total;
  }
}


class ProductSummary {
  final String id;
  final String name;
  final double price;
  final double oldPrice; // zero if no discount
  final int stock;
  final CachedNetworkImageProvider image;

  const ProductSummary({this.id, this.name, this.price, this.oldPrice, this.stock, this.image});

  factory ProductSummary.fromJSON(Map<String, dynamic> json) {
    return ProductSummary(
      id: json['_id']['\$oid'],
      name: json['name'],
      price: json['price'] - json['discount'],
      oldPrice: json['discount'] == 0 ? 0 : json['price'],
      stock: json['stock'],
      image: CachedNetworkImageProvider(json['image']),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final double oldPrice; // zero if no discount
  final int stock;
  final CachedNetworkImageProvider image; // TODO: multiple
  final List<String> subcategories;
  final String description;
  final String information;

  const Product({this.id, this.name, this.price, this.oldPrice, this.stock, this.image, this.subcategories, this.description, this.information});

  factory Product.fromJSON(Map<String, dynamic> json) {
    return Product(
      id: json['_id']['\$oid'],
      name: json['name'],
      price: json['price'] - json['discount'],
      oldPrice: json['discount'] == 0 ? 0 : json['price'],
      stock: json['stock'],
      image: CachedNetworkImageProvider(json['image_list'][0]), //! List
      description: json['description'],
      subcategories: List<String>.from(json['subcategory']),
      information: "Unit       ${json['others']['unit']}\nQuantity   ${json['others']['quantity']}\nCountry    ${json['others']['country']}",
    );
  }

  ProductSummary summary() {
    return ProductSummary(
      id: this.id,
      name: this.name,
      price: this.price,
      oldPrice: this.oldPrice,
      stock: this.stock,
      image: this.image,
    );
  }

  static Future<Product> fromID(String id, Map<String, String> headers) async {
    final response = await http.get(
      Uri.parse('$theURL/product/$id'),
      headers: headers,
    );
    return Product.fromJSON(jsonDecode(response.body));
  }
}


class Order {
  // {order_id: 6085b899166dc691e7e348c41619379276.5519283, 
  // status: pending, 
  // order_time: 1619379276.5519283, 
  // delivery_time: null, 
  // address: My Address, 
  // cart: [{product_id: 605b1597a61de825808a7e84, quantity: 5}, {product_id: 605b1598a61de825808a80d3, quantity: 8}]}
  
  final String id;
  final String status;
  final DateTime orderTime; // DateTime.fromMillisecondsSinceEpoch(int(order_time*1000))
  final DateTime deliveryTime;
  final String address;
  final List<CartItem> cart;

  Order({
    this.id,
    this.status,
    this.orderTime,
    this.deliveryTime,
    this.address,
    this.cart,
  });

  static Future<Order> fromJSON(Map<String, dynamic> json) async {

    List<CartItem> l = [];
    
    for (dynamic i in json['cart']) {
      if (i.isNotEmpty)
        l.add(          
          CartItem(
            productSummary: (await Product.fromID(i['product_id'], {})).summary(),
            quantity: i['quantity']
          )
        );
    }

    return Order(
      id: json['order_id'],
      status: json['status'],
      orderTime: DateTime.fromMillisecondsSinceEpoch((json['order_time'] * 1000).floor()),
      deliveryTime: json['delivery_time']==null ? null : DateTime.fromMillisecondsSinceEpoch((json['delivery_time'] * 1000).floor()),
      address: json['address'],
      cart: l,
    );

  }

}


class Settings {
  final Map<String, String> headers;

  String _email;
  String _password;
  String _username;
  List<String> _addresses;

  Settings({this.headers, String email, String password, String username, List<String> addresses}) {
    this._email = email;
    this._password = password;
    this._username = username;
    this._addresses = addresses;
  }

  String get email => _email;
  String get password => _password;
  String get username => _username;
  List<String> get addresses => _addresses;

  void _changeSettings(Map<String, dynamic> oneValue) async {
    await http.post(
      Uri.parse('$theURL/userprofile'),
      headers: {
        ...contentTypeJSON,
        ...headers,
      },
      body: jsonEncode(oneValue),
    );
  }

  set email(String value) {
    _changeSettings({'email': value});
    _email = value;
  }

  set password(String value) {
    _changeSettings({'password': value});
    _password = value;
  }

  set username(String value) {
    _changeSettings({'username': value});
    _username = value;
  }

  void changeAddress(int index, String value) {
    if (value.isEmpty)
      _addresses.removeAt(index);
    else
      _addresses[index] = value;

    _changeSettings({'address': _addresses});
  }

  void addAddress(String value) {
    _addresses.add(value);
    _changeSettings({'address': _addresses});
  }
}




class DataManager {
  static final DataManager _router = DataManager._internal();
  factory DataManager() => _router;

  String token;
  Map<String, String> get headers => {
    if(this.token != null) 
      "Authorization" : "Bearer $token",
  };
  bool get isSignedIn => (this.token != null);

  Future<Map<String, List<String>>> cat;
  Future<dynamic> home;
  Cart cart;
  Settings settings;

  DataManager._internal() {

    cat = _getCat();
    home = _getHome();
    cart = Cart(headers: this.headers);


  }


  Future<dynamic> _getHome() async {
    final response = await http.get(
      Uri.parse('$theURL/home'),
      headers: this.headers
    );
    final responseJson = jsonDecode(response.body);

    List<String> a = [];
    List<List<ProductSummary>> b = [];

    for (dynamic i in responseJson['content']) {
      a.add(i['title']);
      List<ProductSummary> bb = [];
      for (dynamic j in i['content']) {
        bb.add(ProductSummary.fromJSON(j));
      }
      b.add(bb);  
    }

    return {
      "labels": a,
      "products": b
    };
  }

  Future<Map<String, List<String>>> _getCat() async {
    final response = await http.get(
      Uri.parse('$theURL/cat'),
      headers: this.headers,
    );
    final responseJson = jsonDecode(response.body);

    Map<String, List<String>> toReturn = {};

    for (dynamic i in responseJson) {
      toReturn[i['title']] = List<String>.from(List<dynamic>.from(i['content']).map((e) => e['title']));
    }
    return toReturn;
  }


  void signOut() {
    this.token = null;

    // reload home/cart
    home = _getHome();
    cart = Cart(headers: this.headers);
  }

  Future<String> signIn(String email, String password) async {
    // returns the error message, otherwise an empty string

    if (this.token != null)
      return "Already logged in";

    http.Response r = await http.post(
      Uri.parse('$theURL/auth/login'),
      headers: contentTypeJSON,
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (r.statusCode != 200) {
      try {
        return jsonDecode(r.body)['error'];
      } catch (e) {
        return "An error happened, try again!";
      }
    }

    // SUCCESS
    
    final responseJson = jsonDecode(r.body);
    this.token = responseJson['token'];
    settings = Settings(
      headers: this.headers,
      email: email,
      password: password,
      username: responseJson['username'],
      addresses: List<String>.from(responseJson['address']),
    );

    // reload home/cart
    home = _getHome();
    cart = Cart(headers: this.headers);


    return "";

  }

  Future<String> signUp(String username, String email, String password) async {
    // returns the error message, otherwise an empty string

    if (this.token != null)
      return "Already logged in";

    http.Response r = await http.post(
      Uri.parse('$theURL/auth/signup'),
      headers: contentTypeJSON,
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    final responseJson = jsonDecode(r.body);

    if (r.statusCode != 200) {
      if (responseJson.containsKey('error')) {
        return responseJson['error'];
      } else {
        return "An error happened, try again!";
      }
    }

    // SUCCESS
    
    this.token = responseJson['token'];
    settings = Settings(
      headers: this.headers,
      email: email,
      password: password,
      username: username,
      addresses: [],
    );

    // reload home/cart
    home = _getHome();
    cart = Cart(headers: this.headers);


    return "";

  }


  Future<void> order(String address, String paymentMethod) async {
    await http.post(
      Uri.parse('$theURL/order'),
      headers: {
        ...contentTypeJSON,
        ...headers,
      },
      body: jsonEncode({
        "address": address,
        "payment_method": paymentMethod,
      }),
    ).then((value) {
      this.cart = Cart(headers: this.headers);
    });

  }

  Future<List<Order>> orders() async {
    http.Response r = await http.get(
      Uri.parse('$theURL/order'),
      headers: this.headers,
    );
    final responseJson = jsonDecode(r.body);

    List<Order> l = [];
    for (dynamic i in responseJson) {
      l.add(await Order.fromJSON(i));
    }

    return l;
  }

}





enum SortingType {
  Relevance,
  PriceLowToHigh,
  PriceHighToLow,
}

Future<List<ProductSummary>> searchProduct(String keyword, {
  SortingType sort = SortingType.Relevance, 
  double minPrice,
  double maxPrice,

}) async {

  final response = await http.get(
    Uri.parse('$theURL/search/$keyword'),
    headers: {} // TODO
  );
  return List<ProductSummary>.from(jsonDecode(response.body).map((p) => ProductSummary.fromJSON(p)));

}