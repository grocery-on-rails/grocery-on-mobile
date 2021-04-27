import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:grocery_on_rails/utils/constants.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/utils/navigation.dart';
import 'package:grocery_on_rails/widgets/big_text_container.dart';
import 'package:grocery_on_rails/widgets/rounded_button.dart';
import 'package:grocery_on_rails/widgets/my_form.dart';
import 'package:grocery_on_rails/widgets/edit_screen.dart';
import 'package:grocery_on_rails/pages/orders.dart';


class AccountItem {
  final String title;
  final String subtitle;
  final void Function() onPress;
  final Widget widget;
  const AccountItem({this.title, this.subtitle, this.onPress, this.widget});
}

class AccountPage extends StatefulWidget {

  AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Map<String, List<AccountItem>> _elements;

  @override
  Widget build(BuildContext context) {
    _elements = {
      'SETTINGS': [
        AccountItem(
          title: 'Change Name',
          subtitle: DataManager().settings.username,
          onPress: () {
            EditScreen(
              context: this.context,
              title: "Change Name", 
              form: MyForm(
                actionText: "CHANGE",
                hintTexts: LinkedHashMap.from({
                  "New Name": false,
                }),
                onSubmit: (values) async {
                  DataManager().settings.username = values[0];
                  setState(() {
                    Navigator.pop(context);
                  });
                  return "";
                },
              )
            );
          }
        ), 
        AccountItem(
          title: 'Change Email',
          subtitle: DataManager().settings.email,
          onPress: () {
            EditScreen(
              context: this.context,
              title: "Change Email", 
              form: MyForm(
                actionText: "CHANGE",
                hintTexts: LinkedHashMap.from({
                  "New Email": false,
                }),
                onSubmit: (values) async {
                  DataManager().settings.email = values[0];
                  setState(() {
                    Navigator.pop(context);
                  });
                  return "";
                },
              )
            );
          },
        ),
        AccountItem(
          title: 'Change Password',
          subtitle: "Change your password",
          onPress: () {
            EditScreen(
              context: this.context,
              title: "Change Password", 
              form: MyForm(
                actionText: "CHANGE",
                hintTexts: LinkedHashMap.from({
                  "Old Password": true,
                  "New Password": true,
                  "Retype New Password": true,
                }),
                onSubmit: (values) async {

                  if (values[0] != DataManager().settings.password)
                    return "Wrong Password";

                  if (values[1] != values[2])
                    return "Passwords don't match";

                  DataManager().settings.password = values[2];
                  setState(() {
                    Navigator.pop(context);
                  });
                  return "";
                },
              )
            );
          },
        ),
        AccountItem(
          widget: Theme(
            data: ThemeData(
              accentColor: Colors.black,
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              title: Text(
                'Change Addresses',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
              ),
              subtitle: Text(
                'Add or modify your addresses',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              children: [
                for (int i = 0; i < DataManager().settings.addresses.length; i++)
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 40, right: 5),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        EditScreen(
                          context: context,
                          title: 'Change Address',
                          form: MyForm(
                            actionText: "CHANGE",
                            hintTexts: LinkedHashMap.from({
                              "Address": false
                            }),
                            initalTexts: [
                              DataManager().settings.addresses[i]
                            ],
                            onSubmit: (values) async {
                              
                              DataManager().settings.changeAddress(i, values[0]);

                              setState(() {
                                Navigator.pop(context);
                              });

                              return "";
                            },
                          ),
                        );
                      },
                    ),
                    title: Text(
                      DataManager().settings.addresses[i],
                      style: TextStyle(fontSize: 14,),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 40, right: 5),
                  trailing: IconButton(
                    icon: Icon(Icons.add, color: kColorOrange,),
                    onPressed: () {
                      EditScreen(
                        context: context,
                        title: 'Add New Address',
                        form: MyForm(
                          actionText: "ADD",
                          hintTexts: LinkedHashMap.from({
                            "Address": false
                          }),
                          onSubmit: (values) async {
                            
                            DataManager().settings.addAddress(values[0]);

                            setState(() {
                              Navigator.pop(context);
                            });

                            return "";
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

        ),
      ],
      'ORDERS': [
        AccountItem(
          title: 'View Orders',
          subtitle: 'Display the list of your orders',
          onPress: () {
            DataManager().orders();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrdersPage())
            );
          }
        ),
      ],
      'REACH OUT TO US': [
        AccountItem(
          title: 'Help',
          subtitle: 'Find help by contacting us',
          onPress: () {
            EditScreen(
              context: this.context,
              title: "Contact Us", 
              form: MyForm(
                actionText: "SEND",
                hintTexts: LinkedHashMap.from({
                  "Title": false,
                  "Message": false,
                }),
                onSubmit: (values) async {

                  DataManager().settings.username = values[0];

                  await launch(
                    Mailto(
                        to: ["grocery-on-rails@gmail.com"],
                        subject: values[0],
                        body: values[1],
                    ).toString()
                  );

                  setState(() {
                    Navigator.pop(context);
                  });

                  return "";

                },
              )
            );
          }
        ),
        AccountItem(
          title: 'About Us',
          subtitle: 'Learn more about us, Grocery On Rails',
          onPress: () {
            EditScreen(
              context: this.context,
              title: "About Us", 
              form: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "This app was created as a part of the project of the Software Engineering course taught by professor Luiz Capretz\n\nIt was created by \n    Omar Kallas  => Adminstrator View\n    Phillip Wang => Backend\n    Zayd Maradni => Database\n    Zyad Yasser  => Flutter App\n\n",
                  softWrap: true,
                  style: TextStyle(
                    fontFamily: 'monaco'
                  ),
                ),
              )
            );
          }
        )],
    };

    return BigTextContainer(
      text: "Account",
      children: [
        Expanded(
          child: GroupListView(
            sectionsCount: _elements.keys.toList().length,
            countOfItemInSection: (int section) {
              return _elements.values.toList()[section].length;
            },
            itemBuilder: (BuildContext context, IndexPath index) {
              AccountItem item = _elements.values.toList()[index.section][index.index];
              return item.widget ?? ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text(
                  item.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                ),
                subtitle: Text(
                  item.subtitle,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                onTap: item.onPress,
              );
            },
            groupHeaderBuilder: (BuildContext context, int section) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _elements.keys.toList()[section],
                  style: TextStyle(color: kColorOrange, fontSize: 14, fontWeight: FontWeight.bold,),
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(height: 0,),
            sectionSeparatorBuilder: (context, section) => SizedBox(height: 10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: BigRoundedButton(
            "LOG OUT",
            onPress: () {
              DataManager().signOut();
              toHome();
            },
          ),
        )
      ],
    );
  }
}