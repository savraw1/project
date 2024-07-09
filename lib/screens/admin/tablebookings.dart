import 'package:flutter/material.dart';
import 'package:project/screens/admin/tablef1bookings.dart';
import 'package:project/screens/admin/tablef2bookings.dart';
import 'package:project/screens/admin/tables1bookings.dart';
import 'package:project/screens/admin/tablet1bookings.dart';
import 'package:project/screens/admin/tablet2bookings.dart';

class TableBookings extends StatefulWidget {
  const TableBookings({super.key});

  @override
  State<TableBookings> createState() => _TableBookingsState();
}

class _TableBookingsState extends State<TableBookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, size: 25, color: Colors.indigo),
        ),
        title: Text("Table Bookings"),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: 25),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width*0.8,
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Text("2-seater bookings",style: TextStyle(color: Colors.white, fontSize: 22.5)),
                    SizedBox(height: 25),
                    SizedBox(
                        height: 65,
                        width: MediaQuery.of(context).size.width*0.7,
                        child: ElevatedButton(
                          onPressed: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Tablet1Bookings()));
                          },
                          child: Text(
                            "Table t1",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                              backgroundColor: MaterialStatePropertyAll(Colors.blue.shade900)
                          ),
                        )),
                    SizedBox(height: 25),
                    SizedBox(
                        height: 65,
                        width: MediaQuery.of(context).size.width*0.7,
                        child: ElevatedButton(
                          onPressed: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Tablet2Bookings()));
                          },
                          child: Text(
                            "Table t2",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                              backgroundColor: MaterialStatePropertyAll(Colors.blue.shade900)
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width*0.8,
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Text("4-seater bookings",style: TextStyle(color: Colors.white, fontSize: 22.5)),
                    SizedBox(height: 25),
                    SizedBox(
                        height: 65,
                        width: MediaQuery.of(context).size.width*0.7,
                        child: ElevatedButton(
                          onPressed: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Tablef1Bookings()));
                          },
                          child: Text(
                            "Table f1",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                              backgroundColor: MaterialStatePropertyAll(Colors.blue.shade900)
                          ),
                        )),
                    SizedBox(height: 25),
                    SizedBox(
                        height: 65,
                        width: MediaQuery.of(context).size.width*0.7,
                        child: ElevatedButton(
                          onPressed: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Tablef2Bookings()));
                          },
                          child: Text(
                            "Table f2",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                              backgroundColor: MaterialStatePropertyAll(Colors.blue.shade900)
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Container(
                height: 160,
                width: MediaQuery.of(context).size.width*0.8,
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Text("6-seater bookings",style: TextStyle(color: Colors.white, fontSize: 22.5)),
                    SizedBox(height: 25),
                    SizedBox(
                        height: 65,
                        width: MediaQuery.of(context).size.width*0.7,
                        child: ElevatedButton(
                          onPressed: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Tables1Bookings()));
                          },
                          child: Text(
                            "Table s1",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                              backgroundColor: MaterialStatePropertyAll(Colors.blue.shade900)
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
