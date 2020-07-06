import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notebook/models/categories.dart';
import 'package:notebook/models/notes.dart';
import 'package:notebook/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteDetails extends StatefulWidget {
  String title;

  NoteDetails({this.title});

  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  var formKey = GlobalKey<FormState>();
  var scaffold = GlobalKey<ScaffoldState>();
  var selectedCategory = 1;
  DatabaseHelper dbHelper;
  List<Categories> categories;
  List<String> priorityList;
  String noteTitle, noteContent;
  int selectedPriority=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = List<Categories>();
    priorityList=['Çox vacib',"Vacib","Lazımsız"];
    dbHelper = DatabaseHelper();
    dbHelper.getCategories().then((allCategories) {
      for (Map category in allCategories) {
        categories.add(Categories.fromMap(category));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Qeydin başlığı",
                  labelText: "Başlıq",
                  border: OutlineInputBorder(),
                ),
                onSaved: (titleValue){
                    noteTitle=titleValue;
                },
                validator: (value){
                  if(value.length<3){
                    return "Başlıq 3 hərfdən çox olmalıdır.";
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 20,),
              Center(
                child: categories.length==0 ?
                Center(child: CircularProgressIndicator(),)
                    :
                Row(
                  children: <Widget>[
                    Text("Kateqoriya : ", style: TextStyle(fontSize: 24,),),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 60),
                      margin: const EdgeInsets.symmetric(vertical:10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Theme.of(context).primaryColor)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            items: createNoteDetails(),
                            value: selectedCategory,
                            onChanged: (currentCategory) {
                              setState(() {
                                selectedCategory = currentCategory;
                              });
                            }),
                      ),

                    ),
                  ],
                ),

              ),
              SizedBox(height: 20,),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Qeyd açıqlaması",
                  labelText: "Açıqlama",
                  border: OutlineInputBorder(),
                  fillColor: Theme.of(context).primaryColor
                ),
                onSaved: (contentValue){
                    noteContent=contentValue;
                },
              ),
              SizedBox(height: 20,),
              Center(
                child: priorityList.length==0 ?
                    Center(child: CircularProgressIndicator(),)
                    :
                    Row(
                      children: <Widget>[
                        Text("Prioritet : ", style: TextStyle(fontSize: 24,),),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 60),
                          margin: const EdgeInsets.symmetric(vertical:10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Theme.of(context).primaryColor)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                items: createNotePriority(),
                                value: selectedPriority,
                                onChanged: (priorityValue) {
                                  setState(() {
                                    selectedPriority= priorityValue;
                                  });
                                }),
                          ),

                        ),
                      ],
                    ),

              ),
              SizedBox(height: 20,),

              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    onPressed: (){
                      if(formKey.currentState.validate()){
                        formKey.currentState.save();
                        var now=DateTime.now();
                        dbHelper.insertNote(Notes(selectedCategory,noteTitle,noteContent,selectedPriority,now.toString())).then((value){
                          scaffold.currentState.showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Qeyd uğurla əlavə olundu!'),
                                    Icon(Icons.done)
                                  ],
                                ),
                                duration: Duration(seconds: 3),
                              )
                          );
                          sleep(Duration(seconds: 3));
                          Navigator.pop(context);
                        });
                      }
                  },
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text('Yadda saxla'),
                          Icon(Icons.save)
                        ],
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text('Ləğv et'),
                          Icon(Icons.cancel)
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  createNoteDetails() {
    return categories
        .map(
          (category) => DropdownMenuItem(
            value: category.category_id,
            child: Text(
              category.category_title,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        )
        .toList();
  }

  createNotePriority() {
    return priorityList
        .map(
          (currentPriority) => DropdownMenuItem(
        value: priorityList.indexOf(currentPriority),
        child: Text(
          currentPriority,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    )
        .toList();
  }
}
