import 'package:notebook/models/categories.dart';
import 'package:notebook/models/notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._internal();


  factory DatabaseHelper(){
    if(_databaseHelper==null){
      _databaseHelper=new DatabaseHelper._internal();
      return _databaseHelper;
    }else{
      return _databaseHelper;
    }
  }


  Future<Database> _getDatabase() async{
    if(_database==null){
      _database=await _initializeDatabase();
      return _database;
    }else{
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    var lock = Lock();
    Database _db;

      if (_db == null) {
        await lock.synchronized(() async {
          if (_db == null) {
            var databasesPath = await getDatabasesPath();
            var path = join(databasesPath, 'notesDb.db');
            var file = new File(path);

            // check if file exists
            if (!await file.exists()) {
              // Copy from asset
              ByteData data = await rootBundle.load(join("assets/dbs", 'notes.db'));
              List<int> bytes =
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
              await new File(path).writeAsBytes(bytes);
            }
            // open the database
            _db = await openDatabase(path);
          }
        });
      }

      return _db;
    }


  Future<List<Map<String,dynamic>>> getCategories()async{
      Database db= await _getDatabase();
      var listCategory=db.query('categories');
      return listCategory;
  }

  Future<List<Map<String,dynamic>>> getNotes()async{
    Database db= await _getDatabase();
    var listNotes=db.query('notes',orderBy: 'note_id DESC');
    return listNotes;
  }

  Future<int> insertCategory(Categories category) async{
    Database db = await _getDatabase();
    var insertedCategory= await db.insert('categories',category.toMap());
    return insertedCategory;
  }


  Future<int> insertNote(Notes note) async{
    Database db = await _getDatabase();
    var insertedNote= await db.insert('notes',note.toMap());
    return insertedNote;
  }

  updateNote(Notes note) async{
    Database db = await _getDatabase();
    var result= await db.update('notes',note.toMap(),where: 'note_id = ?',whereArgs: [note.note_id]);
    return result;
  }


  updateCategory(Categories category) async{
    Database db = await _getDatabase();
    var result= await db.update('categories',category.toMap(),where: 'category_id = ?',whereArgs: [category.category_id]);
    return result;
  }

  deleteCategory(int category_id) async{
    Database db = await _getDatabase();
    var result= await db.delete('categories',where: 'category_id = ?',whereArgs: [category_id]);
    return result;
  }

  deleteNote(int note_id) async{
    Database db = await _getDatabase();
    var result= await db.delete('notes',where: 'note_id = ?',whereArgs: [note_id]);
    return result;
  }

  }


