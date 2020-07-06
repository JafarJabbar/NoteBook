import 'package:flutter/material.dart';
import 'package:notebook/models/categories.dart';
import 'package:notebook/models/notes.dart';
import 'screens/note_details.dart';
import 'utils/database_helper.dart';

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
        title: Center(
          child: Text("NoteBook"),
        ),
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteDetails(title: "Yeni qeyd",),),);
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
    allNotes=List<Notes>();
    dbHelper=DatabaseHelper();
    dbHelper.getNotes()
    .then((notes){
      for(Map note in notes){
        allNotes.add(Notes.fromMap(note));
      }
      setState(() {});
    });



  }


  @override
  Widget build(BuildContext context) {
    return allNotes.length<=0 ? Center(child: CircularProgressIndicator(),)
        :
        ListView.builder(itemCount: allNotes.length,itemBuilder: (context,index){
            return ListTile(
              title: Text(allNotes[index].note_title),
            );
        });
  }
}
