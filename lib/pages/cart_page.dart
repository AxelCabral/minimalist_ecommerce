import 'package:flutter/material.dart';
import 'package:minimalist_ecommerce/components/my_button.dart';
import 'package:minimalist_ecommerce/models/product.dart';
import 'package:provider/provider.dart';

import '../models/shop.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  // remove item from cart
  void removeItemFromCart(BuildContext context, Product product) {
    // show a dialog box to ask user to confirm to remove from cart
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Text('Remove this item from your cart?'),
              actions: [
                // cancel button
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),

                // confirm button
                MaterialButton(
                  onPressed: () {
                    // pop dialog box
                    Navigator.pop(context);

                    // add to cart
                    context.read<Shop>().removeFromCart(product);
                  },
                  child: const Text('Confirm'),
                )
              ],
            ));
  }

  // user pressed pay button
  void payButtonPressed(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              content: Text(
                  'User wants to pay! Connect this app to your payment backend'),
            ));
  }

  @override
  Widget build(BuildContext context) {
    // get access to the cart
    final cart = context.watch<Shop>().cart;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cart'),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          // cart list
          Expanded(
              child: cart.isEmpty
                  ? const Center(child: Text('Your cart is empty...'))
                  : ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: ((context, index) {
                        // get individual item in cart
                        final item = cart[index];

                        //return as a cart tile UI
                        return ListTile(
                          title: Text(item.name),
                          subtitle:
                              Text('R\$ ${item.price.toStringAsFixed(2)}'),
                          trailing: IconButton(
                              onPressed: () =>
                                  removeItemFromCart(context, item),
                              icon: const Icon(Icons.remove)),
                        );
                      }))),
          // pay button
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: MyButton(
                onTap: () => payButtonPressed(context),
                child: const Text('PAY NOW')),
          ),
        ],
      ),
    );
  }
}
