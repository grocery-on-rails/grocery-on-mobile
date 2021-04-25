import 'package:flutter/material.dart';
import 'package:grocery_on_rails/utils/network.dart';
import 'package:grocery_on_rails/widgets/shadow_button.dart';

class QuantityModifier extends StatelessWidget {

  final String productID;
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
  final void Function() onPress; // Called when any button is pressed
  
  const QuantityModifier({
    Key key, this.productID, this.primaryColor, this.secondaryColor, this.textColor, this.onPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!DataManager().cart.map.containsKey(this.productID))
      return Container();

    CartItem c = DataManager().cart.map[this.productID];
    bool addButtonActive = (c.quantity < c.productSummary.stock);
    
    return Row(
      children: [
        ShadowCircularButton(
          color: this.secondaryColor,
          icon: Icon(Icons.remove, color: this.primaryColor,),
          onPressed: () {
            DataManager().cart.decrement(c.productSummary);
            this.onPress?.call();
          },
        ),
        SizedBox(
          child: Center(
            child: Text(
              c.quantity.toString(),
              style: TextStyle(
                color: this.textColor,
                fontWeight: FontWeight.bold
              ),
            )
          ),
          width: 30,
        ),
        ShadowCircularButton(
          color: addButtonActive ? this.secondaryColor : this.secondaryColor.withAlpha(100),
          icon: Icon(Icons.add, 
            color: addButtonActive ? this.primaryColor : this.primaryColor.withAlpha(100),
          ),
          onPressed: () {
            if (addButtonActive) {
              DataManager().cart.increment(c.productSummary);
              this.onPress?.call();
            }
          },
        ),
      ]
    );
  }
}
