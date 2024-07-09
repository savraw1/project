import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/user/cart.dart';
import 'package:project/screens/user/location.dart';
import 'package:intl/intl.dart';

class User1 extends StatefulWidget {
  const User1({super.key});

  @override
  State<User1> createState() => _User1State();
}

class _User1State extends State<User1> {
  String? selectedAddress;

  Future<void> _fetchSelectedAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .get();

      if (userDoc.exists && userDoc.data()!.containsKey('addresses')) {
        final addresses = List<Map<String, dynamic>>.from(userDoc['addresses']);
        final selected = addresses.firstWhere(
            (address) => address['selected'] == true,
            orElse: () => {});
        setState(() {
          selectedAddress = selected.isNotEmpty
              ? "${selected['flat']}, ${selected['area']}, ${selected['town']}"
              : null;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSelectedAddress();
  }

  void _showDeleteDialog(String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text('Confirm Cancellation',
              style: TextStyle(color: Colors.white)),
          content: Text('Are you sure you want to delete this order?',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _deleteOrder(orderId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<CartItem> _cartItems = [];

  void _addToCart(CartItem item) {
    setState(() {
      final existingItem = _cartItems.firstWhere(
        (cartItem) => cartItem.id == item.id,
        orElse: () => CartItem(id: '', name: '', imageUrl: '', price: ''),
      );

      if (existingItem.id.isNotEmpty) {
        existingItem.quantity++;
      } else {
        _cartItems.add(item);
      }
    });
  }

  int getTotalItemsInCart() {
    int totalItems = 0;
    for (var item in _cartItems) {
      totalItems += item.quantity;
    }
    return totalItems;
  }

  void _removeFromCart(CartItem item) {
    setState(() {
      _cartItems.remove(item);
    });
  }

  void _deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('HomeDelivery')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('orders')
          .doc(orderId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order cancelled successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cancelling order: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('HomeDelivery')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection('orders')
              .orderBy('orderTime', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: Colors.blue.shade900),
              );
            }

            final orders = snapshot.data!.docs;

            if (orders.isEmpty) {
              return ListView(
                children: [
                  ListTile(
                    title: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Hotel Transylvania",
                        style: TextStyle(color: Colors.indigo, fontSize: 25),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "No orders placed yet",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView(
              children: [
                ListTile(
                  title: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Hotel Transylvania",
                      style: TextStyle(color: Colors.indigo, fontSize: 25),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Booked Orders",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                ...orders.map((order) {
                  final orderId = order.id;
                  final cartItems =
                      List<Map<String, dynamic>>.from(order['cartItems']);
                  final totalAmount = order['totalAmount'];
                  final orderTime = order['orderTime'].toDate();
                  final currentTime = DateTime.now();
                  final timeDifference = currentTime.difference(orderTime);
                  final isDeleteable = timeDifference.inMinutes <
                      1; // Only allow delete within 1 minute

                  final formattedOrderTime =
                      DateFormat('h:mm a\nd MMM, yyyy').format(orderTime);

                  bool status = order['status'];

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: ExpansionTile(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      collapsedShape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      iconColor: Colors.blue.shade900,
                      collapsedIconColor: Colors.blue.shade900,
                      collapsedBackgroundColor: Colors.white10,
                      backgroundColor: Colors.white10,
                      title: Text(
                        'Ordered at $formattedOrderTime',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Total Amount: ₹${totalAmount.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      children: [
                        ...cartItems.map((item) {
                          return ListTile(
                            title: Text("${item['name']} × ${item['quantity']}",
                                style: TextStyle(color: Colors.white)),
                            trailing: Text(
                              '₹${int.parse(item['price']) * item['quantity']}',
                              style: TextStyle(color: Colors.white70, fontSize: 15),
                            ),
                          );
                        }).toList(),
                        // Delivery status toggle
                        ListTile(
                          title: Text(
                            'Status:',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: status
                              ? Text("Delivered",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.green))
                              : Text("Not delivered",
                            style: TextStyle(
                                fontSize: 15, color: Colors.red),
                          ),
                        ),
                        if (isDeleteable) // Only show delete option if within 1 minute
                          ListTile(
                            onTap: () => _showDeleteDialog(orderId),
                            title: Text(
                              'Cancel Order',
                              style: TextStyle(color: Colors.red),
                            ),
                            trailing: Icon(Icons.cancel, color: Colors.red),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
      appBar: AppBar(
        title: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Location(),
                transitionsBuilder: (context, animation1, animation2, child) {
                  var begin = Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation1.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 200),
              ),
            ).then((_) =>
                _fetchSelectedAddress()); // Reload address after returning
          },
          child: Text(
            selectedAddress ?? "Select a location",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.5,
                fontWeight: FontWeight.normal,
                overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          DefaultTabController(
            length: 2,
            child: Expanded(
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Food",
                            style: TextStyle(
                              fontSize: 22.5,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Juice",
                            style: TextStyle(
                              fontSize: 22.5,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: TabBarView(
                      children: [
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Food')
                              .where('isEnabled', isEqualTo: true)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.blue.shade900));
                            }

                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.docs[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    tileColor: Colors.white10,
                                    leading: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: data['foodpic'] != null
                                          ? CachedNetworkImageProvider(data['foodpic'])
                                          : AssetImage('assets/placeholder.png')
                                              as ImageProvider,
                                    ),
                                    title: Text(data['name'],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('₹${data['price']}',
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 18)),
                                        Text(data['desc'],
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 18)),
                                      ],
                                    ),
                                    trailing: FloatingActionButton.small(
                                      onPressed: () {
                                        final currentTime = DateTime.now();
                                        final startTime = DateTime(
                                            currentTime.year,
                                            currentTime.month,
                                            currentTime.day,
                                            10,
                                            0); // 10 AM
                                        final endTime = DateTime(
                                            currentTime.year,
                                            currentTime.month,
                                            currentTime.day,
                                            22,
                                            0); // 10 PM

                                        // Check if the current time is between 10 AM and 10 PM
                                        if (currentTime.isAfter(startTime) &&
                                            currentTime.isBefore(endTime)) {
                                          if (selectedAddress == null ||
                                              selectedAddress!.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Please select a location before adding items to the cart'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          } else {
                                            final cartItem = CartItem(
                                              id: data.id,
                                              name: data['name'],
                                              imageUrl: data['foodpic'],
                                              price: data['price'],
                                            );
                                            _addToCart(cartItem);
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Home delivery is only available from 10 AM to 10 PM'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      },
                                      backgroundColor: Colors.blue.shade900,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child:
                                          Icon(Icons.add, color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Juice')
                              .where('isEnabled',
                                  isEqualTo: true) // Only fetch enabled items
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: Colors.blue.shade900,
                              ));
                            }

                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.docs[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    tileColor: Colors.white10,
                                    leading: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: data['foodpic'] != null
                                          ? CachedNetworkImageProvider(data['foodpic'])
                                          : AssetImage('assets/placeholder.png')
                                              as ImageProvider,
                                    ),
                                    title: Text(data['name'],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Price: ₹${data['price']}',
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 18)),
                                        Text(data['desc'],
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 18)),
                                      ],
                                    ),
                                    trailing: FloatingActionButton.small(
                                      onPressed: () {
                                        final currentTime = DateTime.now();
                                        final startTime = DateTime(
                                            currentTime.year,
                                            currentTime.month,
                                            currentTime.day,
                                            10,
                                            0); // 10 AM
                                        final endTime = DateTime(
                                            currentTime.year,
                                            currentTime.month,
                                            currentTime.day,
                                            22,
                                            0); // 10 PM

                                        // Check if the current time is between 10 AM and 10 PM
                                        if (currentTime.isAfter(startTime) &&
                                            currentTime.isBefore(endTime)) {
                                          if (selectedAddress == null ||
                                              selectedAddress!.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Please select a location before adding items to the cart'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          } else {
                                            final cartItem = CartItem(
                                              id: data.id,
                                              name: data['name'],
                                              imageUrl: data['foodpic'],
                                              price: data['price'],
                                            );
                                            _addToCart(cartItem);
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Home delivery is only available from 10 AM to 10 PM'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      },
                                      backgroundColor: Colors.blue.shade900,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child:
                                          Icon(Icons.add, color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: _cartItems.isNotEmpty ? 85 : 0,
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white10,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _cartItems.isNotEmpty
                ? Row(
                    children: [
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${getTotalItemsInCart()} ${getTotalItemsInCart() == 1 ? 'item' : 'items'} added',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Cart(
                                  cartItems: _cartItems,
                                  onRemoveItem: (CartItem item) {
                                    _removeFromCart(item);
                                    setState(() {});
                                  },
                                  onUpdateCart: () {
                                    setState(() {});
                                  },
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.blue.shade900),
                              shape: MaterialStatePropertyAll(
                                  ContinuousRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)))),
                          child: Text('View Cart',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final String price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  String get totalPrice => (double.parse(price) * quantity).toStringAsFixed(2);
}
