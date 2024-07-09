import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/user/2%20seats.dart';
import 'package:project/screens/user/4%20seats.dart';
import 'package:project/screens/user/6%20seats.dart';
import 'package:intl/intl.dart';

class User4 extends StatefulWidget {
  const User4({super.key});

  @override
  State<User4> createState() => _User4State();
}

class _User4State extends State<User4> {
  List<Map<String, dynamic>> bookedTables = [];

  @override
  void initState() {
    super.initState();
    _fetchBookedTables();
  }

  void _fetchBookedTables() async {
    String? userId = FirebaseAuth.instance.currentUser?.email;

    if (userId != null) {
      List<Map<String, dynamic>> bookings = [];
      List<String> tableTypes = ["2seats", "4seats", "6seats"];

      DateTime currentDate = DateTime.now();
      List<String> pastDates = List.generate(
          15,
              (index) =>
              DateFormat('dd-MM-yyyy').format(currentDate.subtract(Duration(days: index))));
      List<String> futureDates = List.generate(
          15,
              (index) =>
              DateFormat('dd-MM-yyyy').format(currentDate.add(Duration(days: index))));

      List<String> dateRanges = [...pastDates, ...futureDates];

      List<Future> queries = []; // List of all Firestore queries

      for (String tableType in tableTypes) {
        QuerySnapshot tableSnapshot = await FirebaseFirestore.instance
            .collection("Tables_$tableType")
            .get();

        for (var tableDoc in tableSnapshot.docs) {
          String tableId = tableDoc.id;

          for (String date in dateRanges) {
            queries.add(
              FirebaseFirestore.instance
                  .collection("Tables_$tableType")
                  .doc(tableId)
                  .collection("Bookings")
                  .doc(userId)
                  .collection(date)
                  .get()
                  .then((QuerySnapshot dateSnapshot) {
                if (dateSnapshot.docs.isNotEmpty) {
                  for (var bookingDoc in dateSnapshot.docs) {
                    Map<String, dynamic> data = bookingDoc.data() as Map<String, dynamic>;
                    Map<String, dynamic> newBooking = {
                      'tableId': tableId,
                      'date': date,
                      'bookedSlots': data['bookedSlots'] ?? [],
                      'tableType': tableType,
                    };

                    // Check if this booking already exists to prevent duplication
                    if (!bookings.any((b) =>
                    b['tableId'] == newBooking['tableId'] &&
                        b['date'] == newBooking['date'] &&
                        b['tableType'] == newBooking['tableType'])) {
                      bookings.add(newBooking);
                    }
                  }
                }
              }),
            );
          }
        }
      }

      await Future.wait(queries);

      setState(() {
        bookedTables = bookings;
      });
    }
  }

  Future<void> _deleteBooking(String tableId, String slot, String bookingDate, String tableType) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser!.email;

      // Reference to the user's booking in the specified table type collection
      DocumentReference bookedSlotsRef = FirebaseFirestore.instance
          .collection('Tables_$tableType')
          .doc(tableId)
          .collection('Bookings')
          .doc(userId)
          .collection(bookingDate)
          .doc('bookedSlots');

      // Reference to the MainBookings collection for the specific table and date
      DocumentReference mainBookedSlotsRef = FirebaseFirestore.instance
          .collection('MainBookings')
          .doc(tableId)
          .collection(bookingDate)
          .doc('bookedSlots');

      // Fetch and update the user's booked slots
      DocumentSnapshot snapshot = await bookedSlotsRef.get();
      if (snapshot.exists) {
        List<dynamic> bookedSlots = List.from(snapshot['bookedSlots']);
        bookedSlots.remove(slot);

        if (bookedSlots.isEmpty) {
          // Delete the document if no slots remain
          await bookedSlotsRef.delete();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Slot deleted successfully'),
            duration: Duration(seconds: 2),
          ));
        } else {
          // Update the document with remaining slots
          await bookedSlotsRef.update({'bookedSlots': bookedSlots});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Slot deleted successfully'),
            duration: Duration(seconds: 2),
          ));
        }
      }

      // Repeat similar logic for the MainBookings collection
      DocumentSnapshot mainSnapshot = await mainBookedSlotsRef.get();
      if (mainSnapshot.exists) {
        List<dynamic> mainBookedSlots = List.from(mainSnapshot['bookedSlots']);
        mainBookedSlots.remove(slot);

        if (mainBookedSlots.isEmpty) {
          // Delete the document if no slots remain
          await mainBookedSlotsRef.delete();
        } else {
          // Update the document with remaining slots
          await mainBookedSlotsRef.update({'bookedSlots': mainBookedSlots});
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error deleting booking: $e'),
        duration: Duration(seconds: 2),
      ));
    } finally {
      _fetchBookedTables(); // Refresh the list
    }
  }

  void _showDeleteDialog(String tableId, String bookingDate, String slot, String tableType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text('Confirm Deletion', style: TextStyle(color: Colors.white)),
          content: Text('Are you sure you want to delete this booking?', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await _deleteBooking(tableId, slot, bookingDate, tableType);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: MediaQuery.of(context).size.width*0.75,
        child: ListView(
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
                    "Booked Tables",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            bookedTables.isEmpty
                ? ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No bookings available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
                : Column(
              children: bookedTables.map((booking) {
                String tableType = booking['tableType'];
                String tableId = booking['tableId'];
                String bookingDate = booking['date'];
                String tableNumber = tableId.substring(1); // Remove the 't' prefix
                String tableTitle;

                if (tableType == "2seats") {
                  tableTitle = "Booked table $tableNumber for two";
                } else if (tableType == "4seats") {
                  tableTitle = "Booked table $tableNumber for four";
                } else {
                  tableTitle = "Booked table $tableNumber for six";
                }


                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: ExpansionTile(
                    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    collapsedShape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    iconColor: Colors.blue.shade900,
                    collapsedIconColor: Colors.blue.shade900,
                    collapsedBackgroundColor: Colors.white10,
                    backgroundColor: Colors.white10,
                    title: Text(
                      tableTitle,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Date: $bookingDate",
                      style: TextStyle(color: Colors.white70),
                    ),
                    children: [
                      ...booking['bookedSlots'].map<Widget>((slot) {
                        // Parse the slot time and date
                        DateTime slotTime = DateFormat('dd-MM-yyyy hh:mm a').parse('$bookingDate $slot'); // Assuming slot is in "HH:mm" format
                        DateTime currentTime = DateTime.now();

                        // Check if the slot time is in the future
                        bool isSlotInFuture = slotTime.isAfter(currentTime);

                        return ListTile(
                          title: Text(
                            "Booked Slot: $slot",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: isSlotInFuture
                              ? IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteDialog(tableId, bookingDate, slot, tableType);
                            },
                          )
                              : null, // No delete button if the slot is in the past
                        );
                      }).toList(),

                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Text("Book a table"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.1,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Tables_2seats").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(color: Colors.blue.shade900));
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs.map((document) {
                      Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                      String docId = document.id;
                      return InkWell(
                        splashColor: Colors.black,
                        overlayColor: MaterialStateProperty.all(Colors.black),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Booking2Seats(tableId: docId),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width*0.15),
                            Container(
                              height: 60,
                              width: 15,
                              decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            SizedBox(width: 15),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            SizedBox(width: 15),
                            Container(
                              height: 60,
                              width: 15,
                              decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.225,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Tables_4seats").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(color: Colors.blue.shade900));
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs.map((document) {
                      Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                      String docId = document.id;
                      return InkWell(
                        splashColor: Colors.black,
                        overlayColor: MaterialStatePropertyAll(Colors.black),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Booking4Seats(tableId: docId)));
                        },
                        child: Row(
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width*0.12),
                            Column(
                              children: [
                                Row(children: [
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ]),
                                SizedBox(height: 15),
                                Container(
                                  height: 140,
                                  width: 140,
                                  decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                SizedBox(height: 15),
                                Row(children: [
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.225,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Tables_6seats").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(color: Colors.blue.shade900));
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs.map((document) {
                      Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                      String docId = document.id;
                      return InkWell(
                        splashColor: Colors.black,
                        overlayColor: MaterialStatePropertyAll(Colors.black),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Booking6Seats(tableId: docId)));
                          },
                        child: Row(
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width*0.25),
                            Column(
                              children: [
                                Row(children: [
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ]),
                                SizedBox(height: 15),
                                Container(
                                  height: 140,
                                  width: 220,
                                  decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                SizedBox(height: 15),
                                Row(children: [
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
