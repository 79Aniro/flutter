import 'package:chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {

  runApp(MyApp());



 // FirebaseFirestore.instance.collection("col").doc("doc").set({"texto":"aniro"});

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme:IconThemeData(
          color: Colors.blue
        ),


      ),
      home: ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}



