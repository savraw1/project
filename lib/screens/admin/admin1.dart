import 'package:flutter/material.dart';
import 'package:project/screens/admin/homedeliverybookings.dart';
import 'package:project/screens/admin/tablebookings.dart';

class Admin1 extends StatefulWidget {
  const Admin1({super.key});

  @override
  State<Admin1> createState() => _Admin1State();
}

class _Admin1State extends State<Admin1> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home,size: 25,color: Colors.indigo),
        title: Row(
          children: [
            Text("Home"),
          ],
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 65,
                width: 350,
                child: ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeDeliveryBookings()));
                  },
                  child: Text(
                    "Home delivery bookings",
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
                width: 350,
                child: ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TableBookings(),
                      ),
                    );
                  },
                  child: Text(
                    "Table bookings",
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
    );
  }
}