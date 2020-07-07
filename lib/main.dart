import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notebook/models/categories.dart';
import 'package:notebook/models/notes.dart';
import 'package:notebook/screens/category_page.dart';
import 'screens/note_details.dart';
import 'utils/database_helper.dart';
import 'utils/date_helper.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notebook',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: Colors.blue,
        ),
        home: NoteList(),
      ),
    );

var db = DatabaseHelper();

class NoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var key = GlobalKey<FormState>();
    var _scaffold = GlobalKey<ScaffoldState>();
    String categoryName;

    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context){
              return [
                PopupMenuItem(child: ListTile(leading: Icon(Icons.category),title: Text("Kateqoriyalar"),onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                      return CategoryPage();
                  }));
                },))
              ];
            },
          )
        ],
        title: Text("NoteBook"),
      ),
      body: NoteListView(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(
              Icons.add_circle,
            ),
            heroTag: "newCategory",
            tooltip: "Yeni kateqoriya",
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return categoryForm(key, categoryName, context, _scaffold);
                  });
            },
            mini: true,
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetails(
                    title: "Yeni qeyd",
                  ),
                ),
              );
            },
            heroTag: "newNote",
            tooltip: "Yeni qeyd",
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
  Padding categoryForm(GlobalKey<FormState> key, String categoryName,
      BuildContext context, GlobalKey<ScaffoldState> _scaffold) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SimpleDialog(
        title: Text("Yeni kateqoriya"),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: key,
              child: TextFormField(
                onSaved: (value) {
                  categoryName = value;
                },
                decoration: InputDecoration(
                    labelText: "Kateqoriya",
                    border: OutlineInputBorder(),
                    fillColor: Theme.of(context).accentColor),
                validator: (value) {
                  if (value.length < 3) {
                    return "Ad 3 hərfdən böyük olmalıdır ";
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("İmtina"),
                color: Colors.red,
              ),
              RaisedButton(
                onPressed: () {
                  if (key.currentState.validate()) {
                    key.currentState.save();
                    db.insertCategory(Categories(categoryName)).then((value) {
                      if (value > 0) {
                        _scaffold.currentState.showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Kateqoriya uğurla əlavə olundu!'),
                                Icon(Icons.done)
                              ],
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        _scaffold.currentState.showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Bir problem yaşandı!'),
                                Icon(Icons.close)
                              ],
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    });
                  }
                },
                child: Text("Yadda saxla"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class NoteListView extends StatefulWidget {
  @override
  _NoteListViewState createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  List<Notes> allNotes;
  DatabaseHelper dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if(allNotes==null){
      allNotes = List<Notes>();
      getAllNotes();
    }
    return ListView.builder(
        itemCount: allNotes.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(allNotes[index].note_title),
            leading: CircleAvatar(
              backgroundColor: Colors.black26,
              radius: 27,
              child: setPriority(allNotes[index].note_priority),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Başlıq  : "),
                            Text(allNotes[index].note_title)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Kateqoriya  : "),
                            Text(allNotes[index].category_title)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Tarix  : "),
                            Text(DateHelper().dateFormat(DateTime.parse(
                                allNotes[index].note_date)))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Kontent  : "),
                            Text(allNotes[index].note_content)
                          ],
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NoteDetails(
                                    title: "Yeni qeyd",
                                    editNote: allNotes[index]
                                  ),
                                ),
                              );

                            },
                            color: Theme.of(context).primaryColor,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteNote(allNotes[index].note_id);
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              "Qeyd uğurla silindi"
                                          ),
                                          Icon(Icons.done)
                                        ],
                                      )));
                            },
                            color: Colors.red,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  setPriority(int note_priority) {
    var widget;
    switch (note_priority) {
      case 0:
        widget = Text(
          'Çox vacib',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red, fontSize: 12),
        );
        break;
      case 1:
        widget = Text(
          'Vacib',
          style: TextStyle(color: Colors.orange, fontSize: 12),
        );
        break;
      case 2:
        widget = Text(
          'Lazımsız',
          style: TextStyle(color: Colors.green, fontSize: 12),
        );
        break;
    }
    return widget;
  }

  deleteNote(int note_id) {
    dbHelper.deleteNote(note_id);
    setState(() {});
  }

  void getAllNotes() {

    dbHelper.getNoteList().then((value) {
      setState(() {
        allNotes=value;
      });
    });
  }
}
