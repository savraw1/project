import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tablef1Bookings extends StatefulWidget {
  const Tablef1Bookings({super.key});

  @override
  State<Tablef1Bookings> createState() => _Tablef1BookingsState();
}

class _Tablef1BookingsState extends State<Tablef1Bookings> {
  List<Map<String, dynamic>> bookedSlots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookedTables();
  }

  void _fetchBookedTables() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<Map<String, dynamic>> bookings = [];
      DateTime currentDate = DateTime.now();

      List<String> pastDates = List.generate(
          15,
              (index) => DateFormat('dd-MM-yyyy')
              .format(currentDate.subtract(Duration(days: index))));
      List<String> futureDates = List.generate(
          15,
              (index) => DateFormat('dd-MM-yyyy')
              .format(currentDate.add(Duration(days: index))));
      List<String> dateRanges = [...pastDates, ...futureDates];

      QuerySnapshot userSnapshots =
      await FirebaseFirestore.instance.collection("Users").get();

      List<Future> queries = [];

      for (var userDoc in userSnapshots.docs) {
        String userId = userDoc.id;

        for (String date in dateRanges) {
          queries.add(
            FirebaseFirestore.instance
                .collection("Tables_4seats")
                .doc("f1")
                .collection("Bookings")
                .doc(userId)
                .collection(date)
                .get()
                .then((QuerySnapshot dateSnapshot) {
              if (dateSnapshot.docs.isNotEmpty) {
                for (var bookingDoc in dateSnapshot.docs) {
                  Map<String, dynamic> data =
                  bookingDoc.data() as Map<String, dynamic>;
                  Map<String, dynamic> newBooking = {
                    'userId': userId,
                    'date': date,
                    'bookedSlots': data['bookedSlots'] ?? [],
                    'username' : data['username']
                  };

                  if (!bookings.any((b) =>
                  b['userId'] == newBooking['userId'] &&
                      b['date'] == newBooking['date'] &&
                      b['bookedSlots'].toString() ==
                          newBooking['bookedSlots'].toString())) {
                    bookings.add(newBooking);
                  }
                }
              }
            }),
          );
        }
      }

      await Future.wait(queries);

      setState(() {
        bookedSlots = bookings;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching bookings: $e'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> _deleteBookingSlot(
      String userId, String date, String slot) async {
    try {
      DocumentReference userSlotRef = FirebaseFirestore.instance
          .collection("Tables_4seats")
          .doc("f1")
          .collection("Bookings")
          .doc(userId)
          .collection(date)
          .doc("bookedSlots");

      DocumentReference mainBookingRef = FirebaseFirestore.instance
          .collection("MainBookings")
          .doc("f1")
          .collection(date)
          .doc("bookedSlots");

      await userSlotRef.update({
        "bookedSlots": FieldValue.arrayRemove([slot])
      });

      await mainBookingRef.update({
        "bookedSlots": FieldValue.arrayRemove([slot])
      });

      DocumentSnapshot updatedUserDoc = await userSlotRef.get();
      Map<String, dynamic>? updatedUserData =
      updatedUserDoc.data() as Map<String, dynamic>?;

      if (updatedUserData == null ||
          (updatedUserData['bookedSlots'] as List).isEmpty) {
        await userSlotRef.delete();
      }

      DocumentSnapshot updatedMainDoc = await mainBookingRef.get();
      Map<String, dynamic>? updatedMainData =
      updatedMainDoc.data() as Map<String, dynamic>?;

      if (updatedMainData == null ||
          (updatedMainData['bookedSlots'] as List).isEmpty) {
        await mainBookingRef.delete();
      }

      setState(() {
        bookedSlots = bookedSlots.map((booking) {
          if (booking['userId'] == userId && booking['date'] == date) {
            booking['bookedSlots']
                .removeWhere((bookedSlot) => bookedSlot == slot);
          }
          return booking;
        }).where((booking) => booking['bookedSlots'].isNotEmpty).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Booking slot deleted successfully."),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to delete booking slot: $e"),
        duration: Duration(seconds: 2),
      ));
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
          icon: Icon(Icons.arrow_back_ios_new_outlined,
              size: 25, color: Colors.indigo),
        ),
        title: Text("Table f1 Bookings"),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.blue.shade900,
        ),
      )
          : bookedSlots.isEmpty
          ? Center(
        child: Text(
          "No bookings available",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      )
          : ListView.builder(
        itemCount: bookedSlots.length,
        itemBuilder: (context, index) {
          final booking = bookedSlots[index];
          final userId = booking["userId"];
          final date = booking["date"];
          final slots = booking["bookedSlots"];
          final username = booking["username"];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ExpansionTile(
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              collapsedShape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              iconColor: Colors.blue.shade900,
              collapsedIconColor: Colors.blue.shade900,
              collapsedBackgroundColor: Colors.white10,
              backgroundColor: Colors.white10,
              title: Text(
                "$username",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              subtitle: Text(
                "Date: $date",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              tilePadding:
              EdgeInsets.symmetric(vertical: 7.5, horizontal: 25),
              children: slots.map<Widget>((slot) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 25, right: 15),
                  title: Text(
                    "Booked Slot: $slot",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.black87,
                            title: Text("Confirm Deletion",style: TextStyle(color: Colors.white)),
                            content: Text("Are you sure you want to delete this booking?", style: TextStyle(color: Colors.white)),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text(
                                  "Cancel",
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                  _deleteBookingSlot(userId, date, slot);
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}