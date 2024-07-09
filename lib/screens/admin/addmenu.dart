import 'package:flutter/material.dart';

class AddMenu extends StatefulWidget {
  const AddMenu({super.key});

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height*1.1,
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back_ios_new_outlined,size: 30,color: Colors.indigo)),
              title: Text("Add menu",style: TextStyle(color: Colors.white,fontSize: 25)),
            ),
            body: Column(
              children: [
                SizedBox(height: 200),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("     Name",style: TextStyle(color: Colors.white,fontSize: 25,letterSpacing: 1))),
                SizedBox(height: 10),
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: _name,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Colors.white70,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("     Price",style: TextStyle(color: Colors.white,fontSize: 25,letterSpacing: 1))),
                SizedBox(height: 10),
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: _price,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Colors.white70,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 35),
                SizedBox(
                  height: 75,
                  width: 400,
                  child: ElevatedButton(
                    onPressed: (){

                    },
                    child: Text(
                      "Add",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.blue.shade900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
