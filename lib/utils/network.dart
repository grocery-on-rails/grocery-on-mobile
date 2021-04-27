import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:grocery_on_rails/utils/extensions.dart';


const theURL = "https://grocery-on-rails.herokuapp.com";
const Map<String, String> contentTypeJSON = {
  'content-type': 'application/json',
};

extension GetTotal on List<CartItem> {
  double get total {
    double _total = 0;
    for (CartItem c in this)
      _total += c.productSummary.price * c.quantity;
    return _total;
  }
}

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

    String name = json['name'];
    List<String> subCatList = List<String>.from(json['subcategory']);

    //! ONLY LOCAL : NO BACKEND SUPPORT
    int expiryDuration = subCatList.contains('Imperfect') ?
                          (name.length % 3) + 1 :
                          ((name.length+3)*11) + 3;

    String s = "\n";
    try {
      List<List<String>> l = [];

      for (dynamic d in json['others']['info_list']['nutritional_information']) {
        l.add(List<String>.from(d));
        l.last = l.last.sublist(0, l.last.length-1);
      }

      l = l.sublist(0, 4);

      for (int i = 0; i < l[0].length; i++) {
        for (int j = 0; j < l.length; j++) {
          s += l[j][i].padRight(
            l[j].map((e) => e.length).reduce(max)
          ) + ' ';
        }
        s += "\n";
      }

    } catch(e) {
      s = "";
    }


    return Product(
      id: json['_id']['\$oid'],
      name: name,
      price: json['price'] - json['discount'],
      oldPrice: json['discount'] == 0 ? 0 : json['price'],
      stock: json['stock'],
      image: CachedNetworkImageProvider(json['image_list'][0]), //! List
      description: json['description'],
      subcategories: subCatList,
      information: [
        "Expiry Date    ${DateTime.now().add(Duration(days: expiryDuration)).normalFormat}",
        "Unit           ${json['others']['unit']}",
        "Quantity       ${json['others']['quantity']}",
        "Country        ${json['others']['country']}",
        s
      ].join("\n"),
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
  final String id;
  final String status;
  final DateTime orderTime; // DateTime.fromMillisecondsSinceEpoch(int(order_time*1000))
  final DateTime deliveryTime;
  final String address;
  final String paymentMethod;
  final List<CartItem> cart;

  Order({
    this.id,
    this.status,
    this.orderTime,
    this.deliveryTime,
    this.address,
    this.paymentMethod,
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
      paymentMethod: json['payment_method'],
      cart: l,
    );

  }

  String getPaymentObfuscated() {
    if (this.paymentMethod.length >= 4)
      return "**** **** **** ${this.paymentMethod.substring(this.paymentMethod.length - 4)}";
    else
      return "**** **** **** ****";
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
    refreshHome();
    cart = Cart(headers: this.headers);


  }


  void refreshHome() {
    home = _getHome();
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
    refreshHome();
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
    refreshHome();
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
    refreshHome();
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

    // to be in reverse chronological order (recent first)
    return l.reversed.toList();
  }

}





enum SortingType {
  Relevance,
  PriceLowToHigh,
  PriceHighToLow,
}

extension GetIcon on SortingType {
  IconData get icon {
    switch (this) {
      case SortingType.PriceLowToHigh:
        return Icons.arrow_upward_rounded;
      case SortingType.PriceHighToLow:
        return Icons.arrow_downward_rounded;
      case SortingType.Relevance:
      default:
        return Icons.sort;
    }
  }

  String get requestText {
    switch (this) {
      case SortingType.PriceLowToHigh:
        return 'price+';
      case SortingType.PriceHighToLow:
        return 'price-';
      case SortingType.Relevance:
      default:
        return '';
    }  
  }

  String get displayText {
    switch (this) {
      case SortingType.PriceLowToHigh:
        return 'Price Ascending';
      case SortingType.PriceHighToLow:
        return 'Price Descending';
      case SortingType.Relevance:
      default:
        return 'Relevance';
    }
  }
}

SortingType sortingTypeFromDisplayText(String text) {
  switch (text) {
    case 'Price Ascending':
      return SortingType.PriceLowToHigh;
    case 'Price Descending':
      return SortingType.PriceHighToLow;
    case 'Relevance':
    default:
      return SortingType.Relevance;
  }
}

Future<List<ProductSummary>> searchProduct(String keyword, {
  SortingType sort = SortingType.Relevance, 
  String subcategory = ''
}) async {

  final response = await http.post(
    Uri.parse(keyword == '' ?
                '$theURL/search' :
                '$theURL/search/$keyword'),
    headers: contentTypeJSON,
    body: jsonEncode({
      if (sort.requestText != '')
        'sort': sort.requestText,
      if (subcategory != '')
        'subcategory' : subcategory,
    }),
  );

  return List<ProductSummary>.from(jsonDecode(response.body).map((p) => ProductSummary.fromJSON(p)));

}