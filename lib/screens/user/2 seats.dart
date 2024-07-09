import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class Booking2Seats extends StatefulWidget {
  final String tableId;

  Booking2Seats({required this.tableId});

  @override
  _Booking2SeatsState createState() => _Booking2SeatsState();
}

class _Booking2SeatsState extends State<Booking2Seats> {
  DateTime selectedDate = DateTime.now();
  DateTime? selectedTime;
  final userId = FirebaseAuth.instance.currentUser?.email;
  List<String> bookedSlots = [];
  List<String> mainBookedSlots = [];


  @override
  void initState() {
    super.initState();
    _getBookedSlots();
  }

  void _getBookedSlots() async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    if (userId != null) {
      // Fetch user's booked slots
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("Tables_2seats")
          .doc(widget.tableId)
          .collection("Bookings")
          .doc(userId)
          .collection(formattedDate)
          .doc("bookedSlots")
          .get();

      List<dynamic> booked = doc.exists ? doc['bookedSlots'] : [];

      // Fetch main booked slots
      DocumentSnapshot mainDoc = await FirebaseFirestore.instance
          .collection("MainBookings")
          .doc(widget.tableId)
          .collection(formattedDate)
          .doc("bookedSlots")
          .get();

      List<dynamic> mainBooked = mainDoc.exists ? mainDoc['bookedSlots'] : [];

      setState(() {
        bookedSlots = List<String>.from(booked);
        mainBookedSlots = List<String>.from(mainBooked);
        selectedTime = null;
      });
    }
  }

  void _bookSlot() async {
    final user = FirebaseAuth.instance.currentUser;
    if (selectedTime == null || userId == null) return;

    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    String selectedSlot = DateFormat('hh:mm a').format(
      DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime!.hour,
        selectedTime!.minute,
      ),
    );

    // Check if the selected slot is already booked in the main collection
    DocumentSnapshot mainDoc = await FirebaseFirestore.instance
        .collection("MainBookings")
        .doc(widget.tableId)
        .collection(formattedDate)
        .doc("bookedSlots")
        .get();

    var userDoc = await FirebaseFirestore.instance.collection('Users').doc(user?.email).get();
    var username = userDoc['username'] ?? 'Unknown user';

    try {
      // Update the user's bookings
      await FirebaseFirestore.instance
          .collection("Tables_2seats")
          .doc(widget.tableId)
          .collection("Bookings")
          .doc(userId)
          .collection(formattedDate)
          .doc("bookedSlots")
          .set({
        'bookedSlots': FieldValue.arrayUnion([selectedSlot]),
        'tableId': widget.tableId,
        'date': formattedDate,
        'username': username,
        'email' : userId
      }, SetOptions(merge: true));

      // Update the main bookings collection
      await FirebaseFirestore.instance
          .collection("MainBookings")
          .doc(widget.tableId)
          .collection(formattedDate)
          .doc("bookedSlots")
          .set({
        'bookedSlots': FieldValue.arrayUnion([selectedSlot]),
      }, SetOptions(merge: true));

      setState(() {
        selectedTime = null; // Clear selected time after booking
      });
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Table successfully booked')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book the table: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _getBookedSlots();
      });
    }
  }

  Widget _selectTimeSpinner(BuildContext context) {
    return TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(fontSize: 24, color: Colors.white),
      highlightedTextStyle: TextStyle(fontSize: 24, color: Colors.blue),
      spacing: 50,
      itemHeight: 60,
      isForce2Digits: true,
      minutesInterval: 30,
      onTimeChange: (time) {
        DateTime now = DateTime.now();
        DateTime selectedFullDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            time.hour,
            time.minute
        );

        // Ensure the time is between 10:00 AM and 10:00 PM
        if ((time.hour == 10 || time.hour > 10) &&
            (time.hour < 22 || (time.hour == 22 && time.minute == 0))) {
          // Check if selected time is in the future
          if (selectedFullDateTime.isAfter(now)) {
            String selectedSlot = DateFormat('hh:mm a').format(
              DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                time.hour,
                time.minute,
              ),
            );

            // Check if the selected slot is already booked
            if (!mainBookedSlots.contains(selectedSlot)) {
              setState(() {
                selectedTime = time;
              });
            } else {
              setState(() {
                selectedTime = null; // This will disable the button
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('This time slot is already booked')),
              );
            }

          } else {
            // If time is in the past, reset selected time and show error
            setState(() {
              selectedTime = null; // This will disable the button
            });
          }
        } else {
          setState(() {
            selectedTime = null; // This will disable the button
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height*1.25,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_outlined,
                    size: 25, color: Colors.indigo)),
            title: Text("Book a table"),
          ),
          body: Column(
            children: [
              SizedBox(height: 115),
              Text("Select a date:",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    DateFormat('dd-MM-yyyy').format(selectedDate),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text("Select a time between",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              Text("10 AM and 10 PM:",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 25),
              _selectTimeSpinner(context),
              SizedBox(height: 50),
              // Conditional rendering for the "Book" button
              if (selectedTime != null &&
                  !bookedSlots.contains(DateFormat('hh:mm a').format(
                    DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    ),
                  )))
                SizedBox(
                  height: 65,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _bookSlot,
                    child: Text('Book',
                        style: TextStyle(color: Colors.white, fontSize: 22.5)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}