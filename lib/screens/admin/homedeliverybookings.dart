import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'homedeliverydetails.dart';

class HomeDeliveryBookings extends StatefulWidget {
  @override
  _HomeDeliveryBookingsState createState() => _HomeDeliveryBookingsState();
}

class _HomeDeliveryBookingsState extends State<HomeDeliveryBookings> {
  // Function to update the delivery status
  Future<void> _updateDeliveryStatus(String orderId, bool newStatus, String userId) async {

    await FirebaseFirestore.instance
            .collection('HomeDelivery')
            .doc(userId)
            .collection('orders')
            .doc(orderId)
            .update({'status': newStatus});
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined,
              size: 25, color: Colors.indigo),
        ),
        title: Text("Home Delivery Bookings"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collectionGroup('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: Colors.blue.shade900),
            );
          }

          var orders = snapshot.data!.docs;

          // Sort orders in descending order by orderTime
          orders.sort((a, b) {
            Timestamp timestampA = a['orderTime'];
            Timestamp timestampB = b['orderTime'];
            return timestampB.compareTo(timestampA);
          });

          // Check if there are no orders
          if (orders.isEmpty) {
            return Center(
              child: Text(
                "No orders placed yet",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              var username = order['username'];
              var orderId = order.id;
              var userId = order['email'];

              Timestamp orderTimestamp = order['orderTime'];
              DateTime orderDate = orderTimestamp.toDate();

              String formattedDate =
              DateFormat('d MMM, yyyy h:mm a').format(orderDate);

              bool status = order['status']; // Set the initial status from the order

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  tileColor: Colors.white10,
                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 25),
                  title: Row(
                    children: [
                      Text(
                        username,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Spacer(),
                      Text("Delivered?", style: TextStyle(color: Colors.white, fontSize: 17.5, fontWeight: FontWeight.normal)),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Switch(
                          value: status,
                          onChanged: (bool newValue) {
                            _updateDeliveryStatus(orderId, newValue, userId);
                          },
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.red
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeDeliveryDetails(order: order),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
