import 'package:flutter/material.dart';

class AddTable extends StatefulWidget {
  const AddTable({super.key});

  @override
  State<AddTable> createState() => _AddTableState();
}

class _AddTableState extends State<AddTable> {
  bool turn1 = true;
  bool turn2 = true;
  bool turn3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined,size: 30,color: Colors.indigo)),
        title: Text("Add table",style: TextStyle(color: Colors.white,fontSize: 25)),
      ),
      body: Column(
        children: [
          SizedBox(height: 35),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 685,
              width: 425,
              decoration: BoxDecoration(color: Colors.white10,borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  SizedBox(height: 25),
                  Row(
                    children: [
                      SizedBox(width: 50),
                      Text("2 seats",style: TextStyle(color: Colors.white,fontSize: 25,letterSpacing: 1)),
                      SizedBox(width: 85),
                      InkWell(
                        splashColor: Colors.black,
                        overlayColor: MaterialStatePropertyAll(Colors.black),
                        onTap: () {
                          turn1=!turn1;
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 65,
                              width: 15,
                              decoration: BoxDecoration(
                                  color: turn1 ? Colors.grey : Colors.indigo,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            SizedBox(width: 15),
                            Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                  color: turn1 ? Colors.grey : Colors.indigo,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            SizedBox(width: 15),
                            Container(
                              height: 65,
                              width: 15,
                              decoration: BoxDecoration(
                                  color: turn1 ? Colors.grey : Colors.indigo,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Divider(),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      SizedBox(width: 50),
                      Text("4 seats",style: TextStyle(color: Colors.white,fontSize: 25,letterSpacing: 1)),
                      SizedBox(width: 75),
                      InkWell(
                        splashColor: Colors.black,
                        overlayColor: MaterialStatePropertyAll(Colors.black),
                        onTap: () {
                          turn2 = !turn2;
                          setState(() {});
                        },
                        child: Column(
                          children: [
                            Row(children: [
                              Container(
                                height: 15,
                                width: 65,
                                decoration: BoxDecoration(
                                    color: turn2 ? Colors.grey : Colors.indigo,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              SizedBox(width: 20),
                              Container(
                                height: 15,
                                width: 65,
                                decoration: BoxDecoration(
                                    color: turn2 ? Colors.grey : Colors.indigo,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ]),
                            SizedBox(height: 15),
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: turn2 ? Colors.grey : Colors.indigo,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            SizedBox(height: 15),
                            Row(children: [
                              Container(
                                height: 15,
                                width: 65,
                                decoration: BoxDecoration(
                                    color: turn2 ? Colors.grey : Colors.indigo,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              SizedBox(width: 20),
                              Container(
                                height: 15,
                                width: 65,
                                decoration: BoxDecoration(
                                    color: turn2 ? Colors.grey : Colors.indigo,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Divider(),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      SizedBox(width: 50),
                      Text("6 seats",style: TextStyle(color: Colors.white,fontSize: 25,letterSpacing: 1)),
                      SizedBox(width: 35),
                      InkWell(
                        splashColor: Colors.black,
                        overlayColor: MaterialStatePropertyAll(Colors.black),
                        onTap: () {
                          turn3=!turn3;
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Row(children: [
                                  Container(
                                    height: 15,
                                    width: 65,
                                    decoration: BoxDecoration(
                                        color: turn3 ? Colors.grey : Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    height: 15,
                                    width: 65,
                                    decoration: BoxDecoration(
                                        color: turn3 ? Colors.grey : Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    height: 15,
                                    width: 65,
                                    decoration: BoxDecoration(
                                        color: turn3 ? Colors.grey : Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ]),
                                SizedBox(height: 15),
                                Container(
                                  height: 150,
                                  width: 240,
                                  decoration: BoxDecoration(
                                      color: turn3 ? Colors.grey : Colors.indigo,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                SizedBox(height: 15),
                                Row(children: [
                                  Container(
                                    height: 15,
                                    width: 65,
                                    decoration: BoxDecoration(
                                        color: turn3 ? Colors.grey : Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    height: 15,
                                    width: 65,
                                    decoration: BoxDecoration(
                                        color: turn3 ? Colors.grey : Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    height: 15,
                                    width: 65,
                                    decoration: BoxDecoration(
                                        color: turn3 ? Colors.grey : Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 35),
          SizedBox(
            height: 75,
            width: 425,
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
    );
  }
}
