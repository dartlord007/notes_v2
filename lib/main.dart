import 'package:flutter/material.dart';
import 'package:notes_v2/screens/home.dart';

void main() { //shows that the function does not return anything. 
  runApp (const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}