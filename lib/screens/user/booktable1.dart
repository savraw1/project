import 'package:flutter/material.dart';

class User4 extends StatefulWidget {
  const User4({super.key});

  @override
  State<User4> createState() => _User4State();
}

class _User4State extends State<User4> {
  bool turn1 = true;
  bool turn2 = true;
  bool turn3 = true;
  bool turn4 = true;
  bool turn5 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {

            },
            icon: Icon(Icons.menu,
                size: 30, color: Colors.indigo)),
        title: Row(
          children: [
            Text("Book a table",
                style: TextStyle(color: Colors.white, fontSize: 25)),
            Spacer(),
            TextButton(onPressed: (){

            },
                child: Text("Log out"))
          ],
        ),
      ),
      body: Stack(children: [
        Positioned(
          top: 50,
          left: 75,
          child: Row(
            children: [
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
                          color: turn1 ? Colors.grey : Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    SizedBox(width: 15),
                    Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                          color: turn1 ? Colors.grey : Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    SizedBox(width: 15),
                    Container(
                      height: 65,
                      width: 15,
                      decoration: BoxDecoration(
                          color: turn1 ? Colors.grey : Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 50),
              InkWell(
                splashColor: Colors.black,
                overlayColor: MaterialStatePropertyAll(Colors.black),
                onTap: () {
                  turn2=!turn2;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Container(
                      height: 65,
                      width: 15,
                      decoration: BoxDecoration(
                          color: turn2 ? Colors.grey : Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    SizedBox(width: 15),
                    Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                          color: turn2 ? Colors.grey : Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    SizedBox(width: 15),
                    Container(
                      height: 65,
                      width: 15,
                      decoration: BoxDecoration(
                          color: turn2 ? Colors.grey : Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
            top: 175,
            left: 50,
            child: Row(
              children: [
                InkWell(
                  splashColor: Colors.black,
                  overlayColor: MaterialStatePropertyAll(Colors.black),
                  onTap: () {
                    turn3 = !turn3;
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Row(children: [
                        Container(
                          height: 15,
                          width: 65,
                          decoration: BoxDecoration(
                              color: turn3 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 15,
                          width: 65,
                          decoration: BoxDecoration(
                              color: turn3 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ]),
                      SizedBox(height: 15),
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: turn3 ? Colors.grey : Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      SizedBox(height: 15),
                      Row(children: [
                        Container(
                          height: 15,
                          width: 65,
                          decoration: BoxDecoration(
                              color: turn3 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 15,
                          width: 65,
                          decoration: BoxDecoration(
                              color: turn3 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ]),
                    ],
                  ),
                ),
                SizedBox(width: 50),
                InkWell(
                  splashColor: Colors.black,
                  overlayColor: MaterialStatePropertyAll(Colors.black),
                  onTap: () {
                    turn4=!turn4;
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Row(children: [
                        Container(
                          height: 15,
                          width: 65,
                          decoration: BoxDecoration(
                              color: turn4 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 15,
                          width: 65,
                          decoration: BoxDecoration(
                              color: turn4 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ]),
                      SizedBox(height: 15),
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: turn4 ? Colors.grey : Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      SizedBox(height: 15),
                      Row(children: [
                        Container(
                          height: 15,
                          width: 65,
                          decoration: BoxDecoration(
                              color: turn4 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 15,
                          width: 65,
                          decoration: BoxDecoration(
                              color: turn4 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            )),
        Positioned(
            top: 450,
            left: 100,
            child: InkWell(
              splashColor: Colors.black,
              overlayColor: MaterialStatePropertyAll(Colors.black),
              onTap: () {
                turn5=!turn5;
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
                              color: turn5 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 15,
                          width: 65,
                          decoration: BoxDecoration(
                              color: turn5 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 15,
                          width: 65,
                          decoration: BoxDecoration(
                              color: turn5 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ]),
                      SizedBox(height: 15),
                      Container(
                        height: 150,
                        width: 240,
                        decoration: BoxDecoration(
                            color: turn5 ? Colors.grey : Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      SizedBox(height: 15),
                      Row(children: [
                        Container(
                          height: 15,
                          width: 65,
                          decoration: BoxDecoration(
                              color: turn5 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 15,
                          width: 65,
                          decoration: BoxDecoration(
                              color: turn5 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 15,
                          width: 65,
                          decoration: BoxDecoration(
                              color: turn5 ? Colors.grey : Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
            ))
      ]),
    );
  }
}
