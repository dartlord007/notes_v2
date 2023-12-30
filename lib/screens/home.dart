

// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_v2/constants/colors.dart';
import 'package:notes_v2/model/notes.dart';
import 'package:notes_v2/screens/edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Note> filteredNotes = [];
  bool sorted = false;

  @override //override is used here because 
  void initState(){
    super.initState();
    filteredNotes = sampleNotes;
  }

 List<Note> sortModTime(List<Note> notes){
  if(sorted){notes.sort((a,b) => a.modifiedTime.compareTo(b.modifiedTime));} //sorting notes "a" & "b" in ascending order. 
  else{notes.sort((b,a) => a.modifiedTime.compareTo(b.modifiedTime));} //sorting notes "a" & "b" in descending order. 

  sorted = !sorted; //when next this function is called, the sorting order will be reversed. 
  return (notes);
 }

  getRadomColor() {
    Random random =  Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  void onSearchTextChanged (String searchText){
     setState (() {
      filteredNotes = sampleNotes.
          where((note) => 
          note.content.toLowerCase().contains(searchText.toLowerCase()) || note.title.toLowerCase().contains(searchText.toLowerCase()) )
          .toList();});
  }

  void deleteNote (int index){
    Note note = filteredNotes[index];
    sampleNotes.remove(note);
    filteredNotes.removeAt(index);
  }

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
                Text("Notes", style: TextStyle(color: Colors.white, fontSize: 25),),
                IconButton(onPressed: (){
                  setState(() {
                    sortModTime(filteredNotes);
                  });
                },
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.grey.shade800.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.sort)), color: Colors.white)
              ],
            ),
            
            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.all(7.0),
              child: TextField( 
                onChanged: onSearchTextChanged, //value = value entered by user.

                //OR
               
               // onChanged : onSearchTextChanged, 

                style: TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                  hintText: "Search notes...",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey ),
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.transparent)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.transparent))
                ),
              ),
            ),


            Expanded(child: ListView.builder(
              padding: EdgeInsets.only(top: 20),
              itemCount: filteredNotes.length,
              itemBuilder: (context, index){
                return Card(

                  margin: EdgeInsets.only(bottom: 10),
                  color: getRadomColor(),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      onTap: ()async {
                        final result = await Navigator.push(
                                              context, 
                                              MaterialPageRoute(
                                              builder: (BuildContext context) => EditScreen(note: filteredNotes[index]),
                                        ),
                                        );  
                                        if(result != null){
                                            setState(() {
                                              int originalIndex = sampleNotes.indexOf(filteredNotes[index]);
                                              
                                              sampleNotes[originalIndex] = Note(
                                                  id:sampleNotes[originalIndex].id, 
                                                  title:result[0] , 
                                                  content:result[1],
                                                  modifiedTime: DateTime.now());

                                             filteredNotes[index] = Note(
                                                  id:filteredNotes[index].id,
                                                  title:result[0], 
                                                  content:result[1],
                                                  modifiedTime: DateTime.now());
                                            });
                                          }},
                      title: RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        text:
                      TextSpan(
                        text: "${filteredNotes[index].title} \n",
                        style: TextStyle(color: Colors.black, 
                                          fontWeight: FontWeight.bold, 
                                          fontSize: 16,
                                          height: 1.5),
                                  
                                          children: [
                                            TextSpan(
                                              text: filteredNotes[index].content,
                                          style: TextStyle(color: Colors.black, 
                                          fontWeight: FontWeight.normal, 
                                          fontSize: 14,
                                          height: 1.5)
                                            )
                                          ]
                        )
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text('Edited: ${DateFormat("EEE MMM d, yyyy h:mm a").format(sampleNotes[index].modifiedTime)}', 
                             style: TextStyle(color: Colors.grey.shade800, 
                                            fontStyle: FontStyle.italic, 
                                            fontSize: 10,) ),
                        ),
                  
                        trailing: IconButton(onPressed: ()async{
                              final result = await confirmDialog(context);

                            if (result!=null && result ){setState(() {
                            deleteNote(index);
                          }
                          );
                        }
                          }, 
                                  icon: Icon(Icons.delete),),
                    ),
                  ),
                );
              },
            ))
            
             ],
        ),
      ),

      floatingActionButton: FloatingActionButton(onPressed: () async {
         final result = await Navigator.push(
          context, 
          MaterialPageRoute(
           builder: (BuildContext context) => const EditScreen(),
    ),);    

        if(result != null){
          setState(() {
            filteredNotes = sampleNotes;
            sampleNotes.add(
            Note(id:sampleNotes.length, 
                title:result[0] , 
                content:result[1],
                modifiedTime: DateTime.now()),
                
            );
            
          });
        }

      },
      elevation: 10,
      child: Icon(Icons.add, size: 30, color: Colors.grey.shade800,),
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
                          context: context,
                          builder: (BuildContext context)  {                      
                          return AlertDialog (
                            backgroundColor: Colors.grey.shade900,
                            icon: Icon(Icons.info, color: Colors.grey.shade700,),
                            title: Text("Are you sure you want to delete this", style: TextStyle(color: Colors.white ),),

                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [

                              ElevatedButton(onPressed: (){
                                Navigator.pop(context, true);
                              }, 
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: SizedBox(
                                width: 50,
                                height: 20,
                                child: Text("Yes", 
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white ),),
                              )),

                              ElevatedButton(onPressed: (){
                                Navigator.pop(context, false);
                              }, 
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: SizedBox(
                                width: 50,
                                height: 20,
                                child: Text("No", 
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white ),),
                              )),
                            ]),

                          );
                          });
  }
}