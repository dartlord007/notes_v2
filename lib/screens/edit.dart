// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  final TextEditingController _titleController =  TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16,50,16,0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                IconButton(onPressed: (){ Navigator.pop(context);},
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.grey.shade800.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.arrow_back_ios_new)), 
                  color: Colors.white)
              ],
            ),

            Expanded(child: ListView(
              children: [
                TextField(
                  controller: _titleController,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                  decoration: InputDecoration(
                    border:InputBorder.none,
                    hintText: "Title",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 30)
                  )
                ),

                TextField(
                  controller: _contentController,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    border:InputBorder.none,
                    hintText: "Type your notes here...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15)
                  )
                )
              ],
            ),)

          ],
        ),
        
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
                Navigator.pop(context, [_titleController, _contentController]);
      },
                elevation: 10,
                backgroundColor: Colors.grey.shade700,
                child: Icon(Icons.save)
                ),
                
    );
  }
}