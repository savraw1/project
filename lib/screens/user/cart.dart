import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/user/paymentsuccessful.dart';
import 'package:upi_india/upi_india.dart';

import 'homedelivery1.dart';

class Cart extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(CartItem) onRemoveItem;
  final VoidCallback onUpdateCart;

  const Cart({
    super.key,
    required this.cartItems,
    required this.onRemoveItem,
    required this.onUpdateCart,
  });

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int? selectedIndex;
  bool status = false;

  @override
  void initState() {
    super.initState();
    _setInitialSelectedIndex();
  }

  // Calculate the total amount of the cart
  double _calculateTotalAmount() {
    double total = 0;
    for (var item in widget.cartItems) {
      total += double.parse(item.price) * item.quantity;
    }
    return total;
  }

  String formatPrice(double price) {
    if (price == price.toInt()) {
      return '${price.toInt()}';  // No decimal if the number is a whole number
    } else {
      return '${price.toStringAsFixed(2)}';  // Show two decimals if needed
    }
  }

  // Retrieve the initial selected index of the address
  void _setInitialSelectedIndex() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('addresses')) {
          final addresses = List<Map<String, dynamic>>.from(data['addresses']);
          // Find the first address with "selected": true and set selectedIndex
          final initialSelectedIndex =
          addresses.indexWhere((address) => address['selected'] == true);
          setState(() {
            selectedIndex = initialSelectedIndex >= 0 ? initialSelectedIndex : null;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text("Cart"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = widget.cartItems[index];

                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    tileColor: Colors.white10,
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: CachedNetworkImageProvider(cartItem.imageUrl),
                    ),
                    title: Text("${cartItem.name} × ${cartItem.quantity}", style: TextStyle(color: Colors.white, fontSize: 20)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('₹${formatPrice(double.parse(cartItem.totalPrice))}', style: TextStyle(color: Colors.white70, fontSize: 17.5)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red.shade700, size: 30),
                          onPressed: () {
                            setState(() {
                              if (cartItem.quantity > 1) {
                                cartItem.quantity--;
                                widget.onUpdateCart();
                              } else {
                                widget.cartItems.remove(cartItem);
                                widget.onRemoveItem(cartItem);
                                widget.onUpdateCart();
                                if (widget.cartItems.isEmpty) {
                                  Navigator.pop(context); // Pop the page if the cart is empty
                                }
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.green.shade700, size: 30),
                          onPressed: () {
                            setState(() {
                              cartItem.quantity++;
                              widget.onUpdateCart();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      var userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.email).get();
                      var username = userDoc['username'] ?? 'Unknown user';

                      // Retrieve the selected address from the user's addresses
                      final userAddresses = List<Map<String, dynamic>>.from(userDoc['addresses']);
                      final selectedAddress = selectedIndex != null ? userAddresses[selectedIndex!] : null;

                      final cartItems = widget.cartItems.map((item) => {
                        'name': item.name,
                        'price': item.price,
                        'quantity': item.quantity,
                      }).toList();

                      // Add the selected address to the order
                      await FirebaseFirestore.instance
                          .collection('HomeDelivery')
                          .doc(user.email)
                          .collection('orders')
                          .add({
                        'cartItems': cartItems,
                        'totalAmount': _calculateTotalAmount(),
                        'orderTime': Timestamp.now(),
                        'username': username,
                        'email' : user.email,
                        'selectedAddress': selectedAddress ?? {},
                        'status': status
                      });

                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Payment()),
                        );
                      });

                      UpiIndia upiIndia = UpiIndia();
                      final response = await upiIndia.startTransaction(
                        app: UpiApp.googlePay,  // Specify Google Pay as the UPI app
                        receiverUpiId: 'sauravr2001@oksbi',  // Replace with your UPI ID
                        receiverName: 'Saurav R',  // Replace with the receiver name
                        transactionRefId: 'CICAgPDUgNGcKA',  // A unique transaction reference ID
                        transactionNote: 'Hotel Transylvania',  // Optional transaction note
                        amount: _calculateTotalAmount(),  // The total amount to pay
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    'Pay ₹${_calculateTotalAmount().toStringAsFixed(0)} using GPay',
                    style: TextStyle(fontSize: 22.5, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
