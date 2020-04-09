import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'book.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String bookstable = 'books_table';
  String recentstable = 'recent_table';
  String colId = 'id';
  String colpath = '_path';
  String collastpage = '_lastpage';
  String colfavorite = '_favorite';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'books.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $bookstable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colpath TEXT, $collastpage TEXT, $colfavorite TEXT)');
    await db.execute(
        'CREATE TABLE $recentstable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colpath TEXT, $collastpage TEXT, $colfavorite TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getBookslist() async {
    Database db = await this.database;

    // var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(bookstable);
    return result;
  }

  Future<List<Map<String, dynamic>>> get_Recent_Bookslist() async {
    Database db = await this.database;

    // var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(recentstable);
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertBook(Book book) async {
    Database db = await this.database;
    var result = await db.insert(bookstable, book.toMap());
    return result;
  }

  Future<int> insertBook_to_recent(Book book) async {
    book.display_book();
    Database db = await this.database;
    var result = await db.insert(recentstable, book.toMap_for_recent());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateBook(Book book) async {
    var db = await this.database;
    var result = await db.update(bookstable, book.toMap(),
        where: '$colId = ?', whereArgs: [book.id]);
    return result;
  }

  Future<int> update_Recent_Book(Book book) async {
    var db = await this.database;
    var result = await db.update(recentstable, book.toMap_for_recent(),
        where: '$colId = ?', whereArgs: [book.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteBook(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $bookstable WHERE $colId = $id');
    return result;
  }

  Future<int> delete_Recent_Book(int id) async {
    var db = await this.database;
    print(id);
    int result =
        await db.rawDelete('DELETE FROM $recentstable WHERE $colId = $id');
    print(result);
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $bookstable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Book>> getBookofList() async {
    var noteMapList = await getBookslist(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Book> noteList = List<Book>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Book.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }

  Future<List<Book>> get_Recent_BookofList() async {
    var noteMapList =
        await get_Recent_Bookslist(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Book> noteList = List<Book>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Book.from_Recent_MapObject(noteMapList[i]));
    }
    return noteList;
  }
}
