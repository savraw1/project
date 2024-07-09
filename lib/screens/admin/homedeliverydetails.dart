import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeDeliveryDetails extends StatefulWidget {
  final QueryDocumentSnapshot order; // Pass the order document

  const HomeDeliveryDetails({required this.order});

  @override
  _HomeDeliveryDetailsState createState() => _HomeDeliveryDetailsState();
}

class _HomeDeliveryDetailsState extends State<HomeDeliveryDetails> {
  bool status = false;

  @override
  void initState() {
    super.initState();
    // Set the initial delivery status from Firestore
    status = widget.order['status'];
  }

  void _showDeleteDialog(String orderId, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(
              'Confirm Deletion', style: TextStyle(color: Colors.white)),
          content: Text('Are you sure you want to delete this order?',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteOrder(orderId, userId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteOrder(String orderId, String userId) async {
    await FirebaseFirestore.instance
        .collection('HomeDelivery')
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order deleted successfully'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }


  // Update the delivery status in Firestore
  Future<void> _updateDeliveryStatus(String orderId, bool newStatus, String userId) async {

    // Update the order status in the HomeDelivery collection for the specific user
        await FirebaseFirestore.instance
            .collection('HomeDelivery')
            .doc(userId)
            .collection('orders')
            .doc(orderId)
            .update({'status': newStatus});

        setState(() {
          status = newStatus; // Update the local state to reflect the new status
        });
      }

  @override
  Widget build(BuildContext context) {
    var cartItems = widget.order['cartItems'] as List<dynamic>;
    var totalAmount = widget.order['totalAmount'];
    var orderId = widget.order.id;
    var username = widget.order['username'];
    var userId = widget.order['email'];
    Timestamp orderTimestamp = widget.order['orderTime'];
    DateTime orderDate = orderTimestamp.toDate();

    String formattedDate =
    DateFormat('d MMM, yyyy h:mm a').format(orderDate);

    var selectedAddress = widget.order['selectedAddress'] as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined, size: 25, color: Colors.indigo)),
        title: Text("${username}'s Order"),
      ),
      body: Column(
        children: [
          if (selectedAddress != null && selectedAddress.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Address:',
                    style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Street: ${selectedAddress['flat']}',
                    style: TextStyle(color: Colors.white70, fontSize: 17.5),
                  ),
                  Text(
                    'Area: ${selectedAddress['area']}',
                    style: TextStyle(color: Colors.white70, fontSize: 17.5),
                  ),
                  Text(
                    'Landmark: ${selectedAddress['landmark']}',
                    style: TextStyle(color: Colors.white70, fontSize: 17.5),
                  ),
                  Text(
                    'Town/City: ${selectedAddress['town']}',
                    style: TextStyle(color: Colors.white70, fontSize: 17.5),
                  ),
                  Text(
                    'Pin Code: ${selectedAddress['pincode']}',
                    style: TextStyle(color: Colors.white70, fontSize: 17.5),
                  ),
                ],
              ),
            ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Delivered?',
                style: TextStyle(color: Colors.white, fontSize: 17.5),
              ),
              SizedBox(width: 50),
              Switch(
                value: status,
                onChanged: (bool newValue) {
                  _updateDeliveryStatus(orderId, newValue, userId);
                },
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            'Ordered at $formattedDate',
            style: TextStyle(fontSize: 17.5, color: Colors.white),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var item = cartItems[index];
                return ListTile(
                  title: Text("${item['name']} × ${item['quantity']}", style: TextStyle(color: Colors.white, fontSize: 17.5)),
                  trailing: Text("₹${int.parse(item['price']) * item['quantity']}", style: TextStyle(color: Colors.white70, fontSize: 17.5)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Total Amount: ₹${totalAmount.toStringAsFixed(0)}",
              style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: SizedBox(
              height: 65,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                onPressed: () => _showDeleteDialog(orderId, userId),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.red.shade900,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  'Delete this order',
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
